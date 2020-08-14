import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/ad_database.dart';
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
  Stream<Keyword> get keywords$;

  /// [AdRepository] react to the change of Latitude, Longitude values.
  keepWatching(Stream<LatLng> latLng$);
}

class AdRepositoryImpl extends TaskService
    with ServiceMixin, TaskServiceMixin
    implements AdRepository {
  AdRepositoryImpl(
    this._adApiClient,
    this._adDatabase,
    this._creativeDownloader,
    this._config,
  )   : _ads$Controller = StreamController<List<Ad>>(),
        _downloadingAds$Controller = StreamController<List<Ad>>(),
        _readyAds$Controller = BehaviorSubject<List<Ad>>() {
    // Notice that while stopping the downloader is still running and result
    // will keep on storage to retrieve later.
    _creativeDownloader.downloaded$.listen((creative) async {
      // Ad after downloading creative will be pushed to ready stream.
      final ad = await _adDatabase.saveCreative(creative);
      _readyAds$Controller.add([..._readyAds$Controller.value, ad]);
    });
  }

  final AdApiClient _adApiClient;
  final AdDatabase _adDatabase;
  final CreativeDownloader _creativeDownloader;
  final Config _config;

  /// Produces [ads$] stream.
  final StreamController<List<Ad>> _ads$Controller;

  /// Produces [downloadingAds$] stream.
  final StreamController<List<Ad>> _downloadingAds$Controller;

  /// Produces [readyAds$] stream.
  final BehaviorSubject<List<Ad>> _readyAds$Controller;

  Future<List<Ad>> getAds(TargetingValues values) async {
    return [];
  }

  Future<List<Ad>> getDownloadingAds(TargetingValues values) async {
    return [];
  }

  Future<List<Ad>> getReadyList(TargetingValues values) async {
    try {
      return await _adDatabase.getAds();
    } catch (_) {
      return [];
    }
  }

  Future<List<Keyword>> getKeywords() async {
    final List<Keyword> keywords = [];
    final ads = await _adDatabase.getAds();
    for (final ad in ads) {
      keywords.addAll(ad.targetingKeywords);
    }
    return keywords;
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

  Stream<Keyword> get keywords$ {
    return Stream.empty();
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
    Log.info('AdRepository is pulling ads with $_currentLatLng');

    final localAds = await _adDatabase.getAds();

    await _adApiClient.getAds(_currentLatLng).then((List<Ad> res) {
      // compare the result from Ad Server against the current list in local.
      final changeSet = AdDiff.diff(localAds, res);

      Log.info('AdRepository pulled ${res.length} ads'
          ', ${changeSet.numOfNewAds} new'
          ', ${changeSet.numOfUpdatedAds} updated'
          ', ${changeSet.numOfRemovedAds} removed.');

      // remove ads if needs
      if (changeSet.removedAds.length > 0) {
        _adDatabase.removeAds(changeSet.removedAds.map((ad) => ad.id).toList());

        // cancel the download if ad has been added to the downloading queue.
        changeSet.removedAds
            .forEach((ad) => _creativeDownloader.cancelDownload(ad.creative));
      }

      // save ads if needs
      if (changeSet.newAds.length > 0 || changeSet.updatedAds.length > 0)
        _adDatabase.saveAds(changeSet.newAds + changeSet.updatedAds);

      // download new ads first,
      changeSet.newAds.forEach((ad) {
        _creativeDownloader.download(ad.creative);
      });

      // then download updated ads.
      // The downloader would not re-download if creative wasn't changed.
      changeSet.updatedAds.forEach((ad) {
        _creativeDownloader.download(ad.creative);
      });
    });

    return null;
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}
