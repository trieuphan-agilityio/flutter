import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/ad_api_client.dart';
import 'package:ad_bloc/src/service/creative_downloader.dart';
import 'package:ad_bloc/src/service/gps/gps_controller.dart';
import 'package:ad_bloc/src/service/permission_controller.dart';
import 'package:ad_bloc/src/service/power_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static AppBloc of(BuildContext context) {
    return BlocProvider.of<AppBloc>(context);
  }

  AppBloc(
    AppState initialState, {
    @required PermissionController permissionController,
    @required PowerProvider powerProvider,
    @required AdApiClient adApiClient,
    @required CreativeDownloader creativeDownloader,
    @required GpsController gpsController,
  })  : assert(permissionController.isAllowed$.isBroadcast),
        assert(powerProvider.isStrong$.isBroadcast),
        _event$Controller = StreamController.broadcast(),
        _permissionController = permissionController,
        _powerProvider = powerProvider,
        _adApiClient = adApiClient,
        _creativeDownloader = creativeDownloader,
        _gpsController = gpsController,
        super(initialState) {
    // print out downloaded creatives
    _logSubscription = _DebouceBufferPrint.singleton().print$.listen(Log.info);
    _disposer.autoDispose(_logSubscription);
  }

  final PermissionController _permissionController;
  final PowerProvider _powerProvider;
  final AdApiClient _adApiClient;
  final CreativeDownloader _creativeDownloader;
  final GpsController _gpsController;

  StreamSubscription _permissionSubscription;
  StreamSubscription _powerSubscription;

  /// already cancel using [_disposer]
  /// ignore: cancel_subscriptions
  StreamSubscription _logSubscription;

  @override
  Stream<AppState> mapEventToState(AppEvent evt) async* {
    if (evt is Initialized) {
      _permissionSubscription?.cancel();
      _permissionSubscription = _permissionController.isAllowed$.listen(
        (isAllowed) {
          add(Permitted(isAllowed));
        },
      );

      _powerSubscription?.cancel();
      _powerSubscription = _powerProvider.isStrong$.listen(
        (isStrong) {
          add(PowerSupplied(isStrong));
        },
      );

      _permissionController.start();
      _powerProvider.start();
    }

    if (evt is Started) {
      yield state.copyWith(
        isTrackingLocation: true,
      );
      _startTrackingLocation();
    }

    if (evt is Stopped) {
      yield state.copyWith(
        isTrackingLocation: false,
        isFetchingAds: false,
      );
      _stopTrackingLocation();
      _stopFetchingAds();
    }

    if (evt is Permitted) {
      yield state.copyWith(isPermitted: evt.isAllowed);
      yield* _manageService();
    }

    if (evt is PowerSupplied) {
      yield state.copyWith(isPowerStrong: evt.isStrong);
      yield* _manageService();
    }

    if (evt is NewAdsChanged) {
      yield state.copyWith(newAds: evt.ads);
    }

    if (evt is ReadyAdsChanged) {
      yield state.copyWith(readyAds: evt.ads);
    }

    if (evt is Located) {
      if (state.isFetchingAds) {
        yield state.copyWith(latLng: evt.latLng);
      } else {
        yield state.copyWith(latLng: evt.latLng, isFetchingAds: true);
        _startFetchingAds();
      }
    }

    if (evt is Moved) {
      yield state.copyWith(isMoving: evt.isMoving);
      yield* _detectTrip();
      yield* _detectFaces();
    }

    if (evt is GendersDetected) {
      yield state.copyWith(genders: evt.genders);
    }

    if (evt is AgeRangesDetected)
      yield state.copyWith(ageRanges: evt.ageRanges);

    if (evt is KeywordsExtracted) {
      yield state.copyWith(keywords: evt.keywords);
    }

    if (evt is FacesDetected) {
      yield state.copyWith(faces: evt.faces);
      yield* _detectTrip();
      yield* _detectFaces();
    }

    if (evt is AppChangedState) {
      yield evt.state;
    }
  }

  @override
  close() async {
    // stop before disposing
    add(const Stopped());

    _disposer.cancel();

    _permissionController.stop();
    _powerProvider.stop();

    _event$Controller.close();
    super.close();
  }

  Stream<AppState> _manageService() async* {
    if (state.isStopped && state.isPermitted && state.isPowerStrong) {
      yield state.copyWith(isStarted: true);
      add(const Started());
    }

    if (state.isStarted && (state.isNotPermitted || state.isPowerWeak)) {
      yield state.copyWith(isStarted: false);
      add(const Stopped());
    }
  }

  StreamSubscription _trackLocationSubscription;

  _startTrackingLocation() {
    _trackLocationSubscription?.cancel();
    _trackLocationSubscription = _gpsController.latLng$.listen((latLng) {
      add(Located(latLng));
    });

    _disposer.autoDispose(_trackLocationSubscription);

    _gpsController.start();
  }

  _stopTrackingLocation() {
    _trackLocationSubscription?.cancel();
    _trackLocationSubscription = null;
  }

  StreamSubscription _fetchAdSubscription;

  StreamSubscription _creativeDownloadedSubscription;

  _startFetchingAds() {
    fetchAds() async {
      final fetchedAds = await _adApiClient.getAds(state.latLng);

      // compare the result from Ad Server against the current list in local.
      final changeSet = AdDiff.diff(state.readyAds, fetchedAds);

      Log.info('pulled ${fetchedAds.length} ads'
          '${state.latLng == null ? "" : " at ${state.latLng}"}'
          ', ${changeSet.numOfNewAds} new'
          ', ${changeSet.numOfUpdatedAds} updated'
          ', ${changeSet.numOfRemovedAds} removed.');

      // Inform the downloader to cancel the downloading if needs.
      changeSet.removedAds.forEach((ad) {
        return _creativeDownloader.cancelDownload(ad.creative);
      });

      // Inform the ready stream to exclude the removed/updated ads from the list.
      final readyAds = state.readyAds;
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
        add(ReadyAdsChanged(newReadyAds));
      }

      // download new/updated ads
      [...changeSet.newAds, ...changeSet.updatedAds].forEach((ad) {
        _creativeDownloader.download(ad.creative);
      });

      // emit new ads
      add(NewAdsChanged(fetchedAds));
    }

    // eagerly fetch ads
    fetchAds();

    // then periodically fetch ads
    _fetchAdSubscription?.cancel();
    _fetchAdSubscription =
        Stream.periodic(Duration(seconds: 30)).listen((_) => fetchAds());

    _disposer.autoDispose(_fetchAdSubscription);

    _creativeDownloadedSubscription?.cancel();
    // wait for the creative to download and update the ready ads accordingly.
    _creativeDownloadedSubscription =
        _creativeDownloader.downloaded$.listen((downloadedCreative) {
      // log a downloaded creative.
      _DebouceBufferPrint.singleton().increase();

      // Ad after downloading creative success it will be pushed to ready stream.
      Ad downloadedAd;

      try {
        downloadedAd = state.newAds.firstWhere(
          (ad) => ad.creative.id == downloadedCreative.id,
        );
      } catch (_) {
        // not found error
      }

      if (downloadedAd != null) {
        // Updated the ad with new downloaded creative,
        final newReadyAds = [
          ...state.readyAds.where((ad) => ad.id != downloadedAd.id),
          downloadedAd.copyWith(creative: downloadedCreative),
        ];

        // then emit event to update ready ads.
        add(ReadyAdsChanged(newReadyAds));
      }
    });

    _disposer.autoDispose(_creativeDownloadedSubscription);
  }

  _stopFetchingAds() {
    _fetchAdSubscription?.cancel();
    _creativeDownloadedSubscription?.cancel();
  }

  _detectTrip() async* {
    if (state.isMoving && state.faces.isNotEmpty) {
      yield state.copyWith(
        trip: Trip.onTrip(state.faces),
      );
    }

    if (state.isNotMoving && state.faces.isEmpty) {
      yield state.copyWith(
        trip: Trip.offTrip(),
      );
    }
  }

  _detectFaces() async* {
    if (state.trip.isOnTrip) {
      yield state.copyWith(isDetectingFaces: false);
    }

    if (state.isNotMoving) {
      yield state.copyWith(isDetectingFaces: false);
    }

    yield state.copyWith(isDetectingFaces: true);
  }

  @override
  onEvent(AppEvent event) {
    _event$Controller.add(event);
    super.onEvent(event);
  }

  StreamController<AppEvent> _event$Controller;

  @visibleForTesting
  Stream<AppEvent> get event$ => _event$Controller.stream;

  final Disposer _disposer = Disposer();
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
            'observed ${values.length} downloaded creatives.',
          ));
}
