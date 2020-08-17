import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class AdRepository {
  /// returns Ads that match the given Targeting Values
  Future<List<Ad>> getAds(TargetingValues values);

  /// returns downloaded Ads that match the given Targeting Values
  Future<List<Ad>> getReadyList(TargetingValues values);

  /// returns downloading Ads that match the given Targeting Values
  Future<List<Ad>> getDownloadingAds(TargetingValues values);

  /// List of keywords are associated to the ads in this repository.
  Future<List<Keyword>> getKeywords();

  /// Ads that has Creative has just been downloaded.
  Stream<List<Ad>> get readyAds$;

  /// Ads that has Creative is downloading.
  Stream<List<Ad>> get downloadingAds$;

  /// Ads that has just added to repository.
  Stream<List<Ad>> get ads$;

  /// Keywords that has just collected.
  Stream<List<Keyword>> get keywords$;

  /// [AdRepository] react to the change of Latitude, Longitude values.
  keepWatching(Stream<LatLng> latLng$);
}

class AdRepositoryImpl extends TaskService
    with ServiceMixin, TaskServiceMixin
    implements AdRepository {
  /// Produces [ads$] stream.
  final BehaviorSubject<List<Ad>> _ads$Controller;

  /// Produces [downloadingAds$] stream.
  final BehaviorSubject<List<Ad>> _downloadingAds$Controller;

  /// Produces [readyAds$] stream.
  final BehaviorSubject<List<Ad>> _readyAds$Controller;

  /// A client helps to pull ads from Ads Server.
  /// It will be called repeatedly according to the [defaultRefreshInterval].
  final AdApiClient _adApiClient;

  /// A delegate to download [Creative]
  final CreativeDownloader _creativeDownloader;

  /// App config
  final Config _config;

  AdRepositoryImpl(
    this._adApiClient,
    this._creativeDownloader,
    this._config,
  )   : _ads$Controller = BehaviorSubject<List<Ad>>.seeded(const []),
        _downloadingAds$Controller = BehaviorSubject<List<Ad>>.seeded(const []),
        _readyAds$Controller = BehaviorSubject<List<Ad>>.seeded(const []) {
    // Notice that while service is stopping the downloader is still running
    // and result will keep on storage to be retrieved when restart.
    _creativeDownloader.downloaded$.listen((downloadedCreative) async {
      // Ad after downloading creative success it will be pushed to ready stream.
      final ads = _ads$Controller.value;
      final downloadedAd =
          ads.firstWhere((ad) => ad.creative.id == downloadedCreative.id);

      if (downloadedAd != null) {
        // Updated the ad with new downloaded creative,
        final readyAds = [
          ..._readyAds$Controller.value,
          downloadedAd.copyWith(creative: downloadedCreative),
        ];

        // then push it to ready stream.
        _readyAds$Controller.add(readyAds);
      }
    });
  }

  Future<List<Ad>> getAds(TargetingValues values) async {
    return _ads$Controller.value.where((ad) => ad.isMatch(values)).toList();
  }

  Future<List<Ad>> getDownloadingAds(TargetingValues values) async {
    return _downloadingAds$Controller.value
        .where((ad) => ad.isMatch(values))
        .toList();
  }

  Future<List<Ad>> getReadyList(TargetingValues values) async {
    return _readyAds$Controller.value
        .where((ad) => ad.isMatch(values))
        .toList();
  }

  Future<List<Keyword>> getKeywords() async {
    return _readyAds$Controller.value.targetingKeywords;
  }

  Stream<List<Ad>> get ads$ {
    return _ads$Controller.stream;
  }

  Stream<List<Ad>> get readyAds$ {
    return _readyAds$Controller.stream;
  }

  Stream<List<Ad>> get downloadingAds$ {
    return _downloadingAds$Controller.stream;
  }

  Stream<List<Keyword>> get keywords$ {
    return _readyAds$Controller.stream.flatMap<List<Keyword>>((ads) {
      return Stream.value(ads.targetingKeywords);
    });
  }

  /// [_currentLatLng] keeps sync up with [latLng$], when [AdRepository] run its
  /// task to retrieve latest ads from Ad Server, it needs to attach [_currentLatLng]
  /// value with its request.
  keepWatching(Stream<LatLng> latLng$) {
    latLng$.listen((newValue) {
      _currentLatLng = newValue;
    });
  }

  /// ==========================================================================
  /// TaskService
  /// ==========================================================================

  int get defaultRefreshInterval => _config.defaultAdRepositoryRefreshInterval;

  Future<void> start() {
    super.start();
    // get ads from AdServer right after starting.
    _getAds();

    Log.info('AdRepository started.');
    return null;
  }

  Future<void> stop() {
    super.stop();
    Log.info('AdRepository stopped.');
    return null;
  }

  Future<void> runTask() async {
    return _getAds();
  }

  Future<void> _getAds() async {
    // Ad currently are persisted in local storage.
    // Including downloaded Ads, and Ads that are queued up for downloading.
    final localAds = _ads$Controller.value;

    final ads = await _adApiClient.getAds(_currentLatLng);

    // compare the result from Ad Server against the current list in local.
    final changeSet = AdDiff.diff(localAds, ads);

    Log.info('');
    Log.info('AdRepository pulled ${ads.length} ads'
        ', ${changeSet.numOfNewAds} new'
        ', ${changeSet.numOfUpdatedAds} updated'
        ', ${changeSet.numOfRemovedAds} removed.');

    // Inform the downloader to cancel the downloading if needs.
    changeSet.removedAds.forEach((ad) {
      return _creativeDownloader.cancelDownload(ad.creative);
    });

    // Inform the ready stream to exclude the removed ads from the list.
    final readyAds = _readyAds$Controller.value;
    final newReadyAds = readyAds.where((ad) {
      for (final removed in changeSet.removedAds) {
        if (removed.id == ad.id) return false;
      }
      return true;
    }).toList();
    _readyAds$Controller.add(newReadyAds);

    // download new/updated ads
    [...changeSet.newAds, ...changeSet.updatedAds].forEach((ad) {
      _creativeDownloader.download(ad.creative);
    });

    // emit new ads
    _ads$Controller.add(ads);

    return null;
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}
