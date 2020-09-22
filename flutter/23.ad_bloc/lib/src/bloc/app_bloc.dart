import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/ad_repository/ad_repository.dart';
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
    @required AdRepository adRepository,
    @required GpsController gpsController,
  })  : assert(permissionController.isAllowed$.isBroadcast),
        assert(powerProvider.isStrong$.isBroadcast),
        _event$Controller = StreamController.broadcast(),
        _permissionController = permissionController,
        _powerProvider = powerProvider,
        _adRepository = adRepository,
        _gpsController = gpsController,
        super(initialState);

  final PermissionController _permissionController;
  final PowerProvider _powerProvider;
  final AdRepository _adRepository;
  final GpsController _gpsController;

  StreamSubscription _permissionSubscription;
  StreamSubscription _powerSubscription;

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
      return;
    }

    if (evt is Started) {
      yield state.copyWith(
        isTrackingLocation: true,
      );
      _startTrackingLocation();
      return;
    }

    if (evt is Stopped) {
      yield state.copyWith(
        isTrackingLocation: false,
        isFetchingAds: false,
      );
      _stopTrackingLocation();
      _stopFetchingAds();
      return;
    }

    if (evt is Permitted) {
      yield state.copyWith(isPermitted: evt.isAllowed);
      yield* _manageService();
      return;
    }

    if (evt is PowerSupplied) {
      yield state.copyWith(isPowerStrong: evt.isStrong);
      yield* _manageService();
      return;
    }

    if (evt is ChangedGpsOptions) {
      _gpsController.changeGpsOptions(evt.gpsOptions);
      yield state.copyWith(gpsOptions: evt.gpsOptions);
      return;
    }

    if (evt is NewAdsChanged) {
      yield state.copyWith(newAds: evt.ads);
      return;
    }

    if (evt is ReadyAdsChanged) {
      yield state.copyWith(readyAds: evt.ads);
      return;
    }

    if (evt is Located) {
      _adRepository.changeLocation(evt.latLng);

      if (state.isFetchingAds) {
        yield state.copyWith(latLng: evt.latLng);
      } else {
        yield state.copyWith(latLng: evt.latLng, isFetchingAds: true);
        _startFetchingAds();
      }
      return;
    }

    if (evt is Moved) {
      yield state.copyWith(isMoving: evt.isMoving);
      yield* _detectTrip();
      yield* _detectFaces();
      return;
    }

    if (evt is GendersDetected) {
      yield state.copyWith(genders: evt.genders);
      return;
    }

    if (evt is AgeRangesDetected) {
      yield state.copyWith(ageRanges: evt.ageRanges);
      return;
    }

    if (evt is KeywordsExtracted) {
      yield state.copyWith(keywords: evt.keywords);
      return;
    }

    if (evt is FacesDetected) {
      yield state.copyWith(faces: evt.faces);
      yield* _detectTrip();
      yield* _detectFaces();
      return;
    }

    if (evt is AppChangedState) {
      yield evt.state;
      return;
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

  StreamSubscription _adRepositorySubscription;

  _startFetchingAds() {
    _adRepositorySubscription = _adRepository.ads$.listen((ads) {
      if (!listEquals(state.readyAds.toList(), ads.toList()))
        add(ReadyAdsChanged(ads));
    });

    _disposer.autoDispose(_adRepositorySubscription);

    _adRepository.start();
  }

  _stopFetchingAds() {
    _adRepositorySubscription?.cancel();
    _adRepository.stop();
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
