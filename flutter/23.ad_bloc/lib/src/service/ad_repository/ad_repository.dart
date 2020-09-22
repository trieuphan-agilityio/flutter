import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';

import '../debugger_factory.dart';
import '../service.dart';
import 'ad_api_client.dart';
import 'creative_downloader.dart';

abstract class AdRepository implements Service {
  /// Ads that has creatives were downloaded.
  Stream<Iterable<Ad>> get ads$;

  /// List of keywords are associated to the ads in this repository.
  Future<List<Keyword>> getKeywords();

  /// [AdRepository] react to the change of Latitude, Longitude values.
  changeLocation(LatLng latLng);
}

class AdRepositoryImpl with ServiceMixin implements AdRepository {
  AdRepositoryImpl(
    this._adApiClient,
    this._creativeDownloader,
    this._configProvider, {
    AdRepositoryDebugger debugger,
  })  : _debugger = debugger,
        _newAdsSubject = BehaviorSubject<List<Ad>>.seeded(const []),
        _adsSubject = BehaviorSubject<List<Ad>>.seeded(const []) {
    /// background task for fetching Ads from Ad Server.
    backgroundTask = ServiceTask(
      _fetchAds,
      _configProvider.adRepositoryConfig.refreshInterval,
    );

    _configProvider.adRepositoryConfig$.listen((config) {
      backgroundTask?.refreshIntervalSecs = config.refreshInterval;
    });
  }

  /// A client helps to pull ads from Ads Server.
  /// It will be called repeatedly according to the [backgroundTask]'s refresh interval.
  final AdApiClient _adApiClient;

  /// A delegate to download [Creative]
  final CreativeDownloader _creativeDownloader;

  final AdRepositoryConfigProvider _configProvider;

  final AdRepositoryDebugger _debugger;

  /// Produces [ads$] stream.
  final BehaviorSubject<List<Ad>> _newAdsSubject;

  /// Produces [ads$] stream.
  final BehaviorSubject<List<Ad>> _adsSubject;

  Stream<List<Ad>> get ads$ => _ads$ ??= _adsSubject.stream.distinct();
  Stream<List<Ad>> _ads$;

  Stream<List<Ad>> get newAds$ {
    return _newAdsSubject.stream;
  }

  Stream<List<Keyword>> get keywords$ {
    return _adsSubject.stream.flatMap<List<Keyword>>((ads) {
      return Stream.value(ads.targetingKeywords);
    });
  }

  Future<List<Keyword>> getKeywords() async {
    return _adsSubject.value.targetingKeywords;
  }

  /// [_currentLatLng] keeps sync up with the location value,
  /// when [AdRepository] run its task to retrieve latest ads from Ad Server,
  /// it needs to attach [_currentLatLng] value with its request.
  changeLocation(LatLng latLng) {
    _currentLatLng = latLng;
  }

  /// ==========================================================================
  /// TaskService
  /// ==========================================================================

  @override
  start() async {
    super.start();
    // eagerly get ads from Ad Server after starting.
    _fetchAds();

    // Notice that while service is stopping the downloader is still running
    // and result will keep on storage to be retrieved when restart.
    disposer.autoDispose(_creativeDownloader.downloaded$.listen((creative) {
      _onCreativeDownloaded(creative);
      _DebouceBufferPrint.singleton().increase();
    }));

    disposer.autoDispose(
      _DebouceBufferPrint.singleton().print$.listen(Log.info),
    );
  }

  _fetchAds() async {
    // Ad currently are persisted in local storage.
    // Including downloaded Ads, and Ads that are queued up for downloading.
    final localAds = _newAdsSubject.value;

    final fetchedAds = await _adApiClient.getAds(_currentLatLng);

    // compare the result from Ad Server against the current list in local.
    final changeSet = AdDiff.diff(localAds, fetchedAds);

    final latLng = _currentLatLng;
    Log.info('AdRepository pulled ${fetchedAds.length} ads'
        '${latLng == null ? "" : " at ${latLng.lat} ${latLng.lng}"}'
        ', ${changeSet.numOfNewAds} new'
        ', ${changeSet.numOfUpdatedAds} updated'
        ', ${changeSet.numOfRemovedAds} removed.');

    // Inform the downloader to cancel the downloading if needs.
    changeSet.removedAds.forEach((ad) {
      return _creativeDownloader.cancelDownload(ad.creative);
    });

    // Inform the ready stream to exclude the removed/updated ads from the list.
    final readyAds = _adsSubject.value;
    final newReadyAds = readyAds.where((ad) {
      for (final removed in changeSet.removedAds) {
        if (removed.id == ad.id) return false;
      }
      for (final updated in changeSet.updatedAds) {
        if (updated.id == ad.id) return false;
      }
      return true;
    }).toList();

    if (!listEquals(readyAds, newReadyAds)) {
      _adsSubject.add(newReadyAds);
    }

    // download new/updated ads
    [...changeSet.newAds, ...changeSet.updatedAds].forEach((ad) {
      _creativeDownloader.download(ad.creative);
    });

    // emit new ads
    _newAdsSubject.add(fetchedAds);
  }

  _onCreativeDownloaded(Creative downloadedCreative) {
    // Ad after downloading creative success it will be pushed to ready stream.
    final newAds = _newAdsSubject.value;

    Ad downloadedAd;

    try {
      downloadedAd = newAds.firstWhere(
        (ad) => ad.creative.id == downloadedCreative.id,
      );
    } catch (_) {
      // not found error
    }

    if (downloadedAd != null) {
      // Updated the ad with new downloaded creative,
      final readyAds = [
        ..._adsSubject.value.where((ad) => ad.id != downloadedAd.id),
        downloadedAd.copyWith(creative: downloadedCreative),
      ];

      // then push it to ready stream.
      _adsSubject.add(readyAds);
    }
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}

class _DebouceBufferPrint {
  factory _DebouceBufferPrint.singleton() {
    if (_shared == null) _shared = _DebouceBufferPrint._();
    return _shared;
  }
  _DebouceBufferPrint._() : _controller = StreamController.broadcast();
  static _DebouceBufferPrint _shared;

  StreamController<void> _controller;

  increase() {
    _controller.add(null);
  }

  Stream<String> get print$ => _controller.stream
      .debounceBuffer(Duration(milliseconds: 500))
      .where((values) => values.length > 0)
      .flatMap((values) => Stream.value(
            'AdRepository observed ${values.length} downloaded creatives.',
          ));
}
