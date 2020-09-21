import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/ad_api_client.dart';
import 'package:ad_bloc/src/service/creative_downloader.dart';
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
  })  : assert(permissionController.isAllowed$.isBroadcast),
        assert(powerProvider.isStrong$.isBroadcast),
        _permissionController = permissionController,
        _powerProvider = powerProvider,
        _adApiClient = adApiClient,
        _creativeDownloader = creativeDownloader,
        super(initialState) {
    // print out downloaded creatives
    _logSubscription = _DebouceBufferPrint().print$.listen(Log.info);
  }

  final PermissionController _permissionController;
  final PowerProvider _powerProvider;
  final AdApiClient _adApiClient;
  final CreativeDownloader _creativeDownloader;

  StreamSubscription _permissionSubscription;
  StreamSubscription _powerSubscription;
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
      _startFetchingAds();
    }

    if (evt is Stopped) {
      yield state.copyWith(
        isTrackingLocation: false,
      );
      _stopFetchingAds();
    }

    if (evt is Permitted) {
      yield state.copyWith(isPermitted: evt.isAllowed);
      _manageService();
    }

    if (evt is PowerSupplied) {
      yield state.copyWith(isPowerStrong: evt.isStrong);
      _manageService();
    }

    if (evt is NewAdsChanged) {
      yield state.copyWith(newAds: evt.ads);
    }

    if (evt is ReadyAdsChanged) {
      yield state.copyWith(readyAds: evt.ads);
    }

    if (evt is Located) {
      yield state.copyWith(latLng: evt.latLng);
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
  }

  @override
  close() async {
    // stop before disposing
    add(const Stopped());

    _logSubscription?.cancel();
    _permissionSubscription?.cancel();
    _powerSubscription?.cancel();

    _permissionController.stop();
    _powerProvider.stop();

    super.close();
  }

  _manageService() async {
    if (state.isPermitted && state.isPowerStrong) {
      // services should start
      add(const Started());
    }

    if (state.isNotPermitted || state.isPowerWeak) {
      // services should stop
      add(const Stopped());
    }
  }

  StreamSubscription _fetchAdSubscription;

  StreamSubscription _creativeDownloadedSubscription;

  _startFetchingAds() {
    _fetchAdSubscription?.cancel();
    _fetchAdSubscription = Stream.periodic(
      Duration(seconds: 30),
    ).listen((_) async {
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
    });

    _creativeDownloadedSubscription?.cancel();

    // wait for the creative to download and update the ready ads accordingly.
    _creativeDownloadedSubscription =
        _creativeDownloader.downloaded$.listen((downloadedCreative) {
      // log a downloaded creative.
      _DebouceBufferPrint().increase();

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
          ...state.readyAds,
          downloadedAd.copyWith(creative: downloadedCreative),
        ];

        // then emit event to update ready ads.
        add(ReadyAdsChanged(newReadyAds));
      }
    });
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
}

class _DebouceBufferPrint {
  factory _DebouceBufferPrint() {
    if (_shared == null) _shared = _DebouceBufferPrint._();
    return _shared;
  }

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

  _DebouceBufferPrint._() : _controller = StreamController.broadcast();
  static _DebouceBufferPrint _shared;
}
