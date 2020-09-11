import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/models/ad.dart';
import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/ad/ad_api_client.dart';
import 'package:ad_stream/src/modules/ad/creative_downloader.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:rxdart/rxdart.dart';

import 'debugger/ad_repository_debugger.dart';

abstract class AdRepository {
  /// Ads that has creatives were downloaded.
  Stream<List<Ad>> get ads$;

  /// List of keywords are associated to the ads in this repository.
  Future<List<Keyword>> getKeywords();

  /// [AdRepository] react to the change of Latitude, Longitude values.
  keepWatching(Stream<LatLng> latLng$);
}

class AdRepositoryImpl
    with ServiceMixin<List<Ad>>
    implements AdRepository, Service {
  /// Produces [ads$] stream.
  final BehaviorSubject<List<Ad>> _newAds$Controller;

  /// Produces [downloadingAds$] stream.
  final BehaviorSubject<List<Ad>> _downloadingAds$Controller;

  /// Produces [ads$] stream.
  final BehaviorSubject<List<Ad>> _ads$Controller;

  /// A client helps to pull ads from Ads Server.
  /// It will be called repeatedly according to the [backgroundTask]'s refresh interval.
  final AdApiClient _adApiClient;

  /// A delegate to download [Creative]
  final CreativeDownloader _creativeDownloader;

  final AdRepositoryConfigProvider _configProvider;

  final AdRepositoryDebugger _debugger;

  AdRepositoryImpl(
    this._adApiClient,
    this._creativeDownloader,
    this._configProvider, {
    AdRepositoryDebugger debugger,
  })  : _debugger = debugger,
        _newAds$Controller = BehaviorSubject<List<Ad>>.seeded(const []),
        _downloadingAds$Controller = BehaviorSubject<List<Ad>>.seeded(const []),
        _ads$Controller = BehaviorSubject<List<Ad>>.seeded(const []) {
    // Notice that while service is stopping the downloader is still running
    // and result will keep on storage to be retrieved when restart.
    _creativeDownloader.downloaded$.listen(_onCreativeDownloaded);

    /// background task for fetching Ads from Ad Server.
    backgroundTask = ServiceTask(
      _fetchAds,
      _configProvider.adRepositoryConfig.refreshInterval,
    );

    _configProvider.adRepositoryConfig$.listen((config) {
      backgroundTask?.refreshIntervalSecs = config.refreshInterval;
    });

    acceptDebugger(_debugger, originalValue$: _ads$Controller.stream);
  }

  Stream<List<Ad>> get ads$ => _ads$ ??= value$.distinct();
  Stream<List<Ad>> _ads$;

  Stream<List<Ad>> get downloadingAds$ {
    return _downloadingAds$Controller.stream;
  }

  Stream<List<Ad>> get newAds$ {
    return _newAds$Controller.stream;
  }

  Stream<List<Keyword>> get keywords$ {
    return _ads$Controller.stream.flatMap<List<Keyword>>((ads) {
      return Stream.value(ads.targetingKeywords);
    });
  }

  Future<List<Keyword>> getKeywords() async {
    return _ads$Controller.value.targetingKeywords;
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

  @override
  start() async {
    super.start();
    // get ads from AdServer right after starting.
    _fetchAds();
  }

  _fetchAds() async {
    // Ad currently are persisted in local storage.
    // Including downloaded Ads, and Ads that are queued up for downloading.
    final localAds = _newAds$Controller.value;

    final ads = await _adApiClient.getAds(_currentLatLng);

    // compare the result from Ad Server against the current list in local.
    final changeSet = AdDiff.diff(localAds, ads);

    Log.info('AdRepository pulled ${ads.length} ads'
        '${_currentLatLng == null ? "" : " at $_currentLatLng"}'
        ', ${changeSet.numOfNewAds} new'
        ', ${changeSet.numOfUpdatedAds} updated'
        ', ${changeSet.numOfRemovedAds} removed.');

    // Inform the downloader to cancel the downloading if needs.
    changeSet.removedAds.forEach((ad) {
      return _creativeDownloader.cancelDownload(ad.creative);
    });

    // Inform the ready stream to exclude the removed ads from the list.
    final readyAds = _ads$Controller.value;
    final newReadyAds = readyAds.where((ad) {
      for (final removed in changeSet.removedAds) {
        if (removed.id == ad.id) return false;
      }
      return true;
    }).toList();
    _ads$Controller.add(newReadyAds);

    // download new/updated ads
    [...changeSet.newAds, ...changeSet.updatedAds].forEach((ad) {
      _creativeDownloader.download(ad.creative);
    });

    // emit new ads
    _newAds$Controller.add(ads);
  }

  _onCreativeDownloaded(Creative downloadedCreative) {
    // Ad after downloading creative success it will be pushed to ready stream.
    final ads = _newAds$Controller.value;

    Ad downloadedAd;

    try {
      downloadedAd = ads.firstWhere(
        (ad) => ad.creative.id == downloadedCreative.id,
      );
    } catch (_) {
      // not found error
    }

    if (downloadedAd != null) {
      // Updated the ad with new downloaded creative,
      final readyAds = [
        ..._ads$Controller.value,
        downloadedAd.copyWith(creative: downloadedCreative),
      ];

      // then push it to ready stream.
      _ads$Controller.add(readyAds);
    }
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}
