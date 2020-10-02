import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/config.dart';
import 'package:ad_bloc/model.dart';

import '../debugger_builder.dart';
import '../service.dart';
import 'ad_api_client.dart';
import 'creative_downloader.dart';

abstract class AdRepository implements Service {
  /// Ads that has creatives were downloaded.
  Stream<Iterable<Ad>> get ads$;

  /// List of keywords are associated to the ads in this repository.
  Future<Iterable<Keyword>> getKeywords();

  /// [AdRepository] react to the change of Latitude, Longitude values.
  changeLocation(LatLng latLng);
}

class AdRepositoryImpl with ServiceMixin implements AdRepository {
  AdRepositoryImpl(
    this._adApiClient,
    this._creativeDownloader,
    this._adConfigProvider,
    this._configProvider, {
    AdRepositoryDebugger debugger,
  })  : _debugger = debugger,
        _newAdsSubject = BehaviorSubject<Iterable<Ad>>.seeded(const []),
        _adsSubject = BehaviorSubject<Iterable<Ad>>.seeded(const []) {
    if (_debugger == null) {
      /// background task for fetching Ads from Ad Server.
      backgroundTask = ServiceTask(
        _fetchAds,
        _configProvider.adRepositoryConfig.refreshInterval,
      );

      _configProvider.adRepositoryConfig$.listen((config) {
        backgroundTask?.refreshIntervalSecs = config.refreshInterval;
      });
    }
  }

  /// A client helps to pull ads from Ads Server.
  /// It will be called repeatedly according to the [backgroundTask]'s refresh interval.
  final AdApiClient _adApiClient;

  /// A delegate to download [Creative]
  final CreativeDownloader _creativeDownloader;

  final AdRepositoryConfigProvider _configProvider;

  final AdConfigProvider _adConfigProvider;

  final AdRepositoryDebugger _debugger;

  /// Produces [ads$] stream.
  final BehaviorSubject<Iterable<Ad>> _newAdsSubject;

  /// Produces [ads$] stream.
  final BehaviorSubject<Iterable<Ad>> _adsSubject;

  Stream<Iterable<Ad>> get ads$ => _ads$ ??= _adsSubject.stream.distinct();
  Stream<Iterable<Ad>> _ads$;

  Stream<Iterable<Ad>> get newAds$ {
    return _newAdsSubject.stream;
  }

  Stream<Iterable<Keyword>> get keywords$ {
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

    // run with debugger if it's enabled.
    if (_debugger != null) {
      disposer.autoDispose(_debugger.ads$.listen(_adsSubject.add));
      return;
    }

    // eagerly get ads from Ad Server after starting.
    _fetchAds();

    // Notice that while service is stopping the downloader is still running
    // and result will keep on storage to be retrieved when restart.

    final subscription = _creativeDownloader.downloaded$
        .debounceBuffer(Duration(milliseconds: 500))
        .listen((creatives) {
      Log.info(
          'AdRepository observed ${creatives.length} downloaded creatives.');
      _onCreativesDownloaded(creatives);
    });

    disposer.autoDispose(subscription);
  }

  _fetchAds() async {
    // Ad currently are persisted in local storage.
    // Including downloaded Ads, and Ads that are queued up for downloading.
    final localAds = _newAdsSubject.value;

    List<Ad> fetchedAds = await _adApiClient.getAds(_currentLatLng);

    if (_adConfigProvider.adConfig.defaultAdEnabled &&
        _adConfigProvider.adConfig.defaultAd != null) {
      fetchedAds.add(_adConfigProvider.adConfig.defaultAd);
    }

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
    });

    if (!listEquals(readyAds.toList(), newReadyAds.toList())) {
      _adsSubject.add(newReadyAds);
    }

    // download new/updated ads
    [...changeSet.newAds, ...changeSet.updatedAds].forEach((ad) {
      _creativeDownloader.download(ad.creative);
    });

    List<Ad> prioritized = [];
    fetchedAds.asMap().forEach((index, ad) {
      // if display property is not assigned yet, then let's prioritize by
      // the order in the list.
      if (ad.displayPriority == -1) {
        // set the displaying order
        prioritized.add(ad.copyWith(displayPriority: index));
      } else {
        prioritized.add(ad);
      }
    });

    // emit new ads
    _newAdsSubject.add(prioritized);
  }

  _onCreativesDownloaded(Iterable<Creative> downloadedCreatives) {
    // Ad after downloading creative success it will be pushed to ready stream.
    final newAds = _newAdsSubject.value;

    Iterable<Ad> downloadedAds;

    try {
      downloadedAds = newAds.where(
        (ad) => downloadedCreatives.map((c) => c.id).contains(ad.creative.id),
      );
    } catch (_) {
      // not found error
    }

    if (downloadedAds != null) {
      // (!) update the ready ads with new downloaded creatives.
      final readyAds = [
        ..._adsSubject.value.where(
          (ad) => !downloadedAds.map((a) => a.id).contains(ad.id),
        ),
        ...downloadedAds.map(
          (ad) => ad.copyWith(
            creative: downloadedCreatives.firstWhere(
              (creative) => ad.creative.id == creative.id,
            ),
          ),
        ),
      ];

      // then push it to ready stream.
      _adsSubject.add(readyAds);

      /*
      An utility to generate Ads data for integration tests
      =====================================================

      final adString =
          readyAds.map((ad) => '${ad.shortId}-${ad.version}').join(',');

      final adToPrint = downloadedAds.map(
        (ad) => ad.copyWith(
          creative: downloadedCreatives.firstWhere(
            (creative) => ad.creative.id == creative.id,
          ),
        ),
      );

      print('===csv ${stopwatch.elapsedMilliseconds},$adString');
      for (final ad in adToPrint) print('=== ad ${ad.toConstructableString()}');
      */
    }
  }

  /// Save the latest value of from LatLng stream.
  /// Whenever call AdClientApi, this value would be sent to the Ad Server.
  LatLng _currentLatLng;
}
