import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/ad_repository/ad_repository.dart';
import 'package:ad_bloc/src/service/age_detector.dart';
import 'package:ad_bloc/src/service/camera_controller.dart';
import 'package:ad_bloc/src/service/face_detector.dart';
import 'package:ad_bloc/src/service/gender_detector.dart';
import 'package:ad_bloc/src/service/gps/gps_controller.dart';
import 'package:ad_bloc/src/service/movement_detector.dart';
import 'package:ad_bloc/src/service/permission_controller.dart';
import 'package:ad_bloc/src/service/power_provider.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static AppBloc of(BuildContext context) {
    return BlocProvider.of<AppBloc>(context);
  }

  AppBloc(
    AppState initialState, {
    PermissionController permissionController,
    PowerProvider powerProvider,
    AdRepository adRepository,
    GpsController gpsController,
    MovementDetector movementDetector,
    CameraController cameraController,
    FaceDetector faceDetector,
    GenderDetector genderDetector,
    AgeDetector ageDetector,
  })  : assert(permissionController == null ||
            permissionController.isAllowed$.isBroadcast),
        assert(powerProvider == null || powerProvider.isStrong$.isBroadcast),
        _eventController = StreamController.broadcast(),
        _permissionController = permissionController,
        _powerProvider = powerProvider,
        _adRepository = adRepository,
        _gpsController = gpsController,
        _cameraController = cameraController,
        _movementDetector = movementDetector,
        _faceDetector = faceDetector,
        _genderDetector = genderDetector,
        _ageDetector = ageDetector,
        super(initialState);

  PermissionController _permissionController;
  PowerProvider _powerProvider;
  AdRepository _adRepository;
  GpsController _gpsController;
  CameraController _cameraController;
  MovementDetector _movementDetector;
  FaceDetector _faceDetector;
  GenderDetector _genderDetector;
  AgeDetector _ageDetector;

  StreamSubscription _permissionSubscription;
  StreamSubscription _powerSubscription;

  @override
  Stream<AppState> mapEventToState(AppEvent evt) async* {
    if (evt is Initialized) {
      _verifyPermission();
      _verifyPower();
      return;
    }

    if (evt is Permitted) {
      yield state.copyWith(isPermitted: evt.isAllowed);
      yield* _startOrStopIfNeeds();
      return;
    }

    if (evt is PowerSupplied) {
      yield state.copyWith(isPowerStrong: evt.isStrong);
      yield* _startOrStopIfNeeds();
      return;
    }

    if (evt is ChangedGpsOptions) {
      yield state.copyWith(gpsOptions: evt.gpsOptions);
      _gpsController?.changeGpsOptions(evt.gpsOptions);
      return;
    }

    if (evt is ReadyAdsChanged) {
      yield state.copyWith(readyAds: evt.ads);
      return;
    }

    if (evt is Located) {
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
      _capturePhotoIfNeeds();
      _updateTripStateIfNeeds();
      return;
    }

    if (evt is PhotoCaptured) {
      yield state.copyWith(capturedPhoto: evt.photo);
      _detectFaces();
      return;
    }

    if (evt is DetectedNoFace) {
      yield state.copyWith(faces: const []);
      _updateTripStateIfNeeds();
      return;
    }

    if (evt is FacesDetected) {
      yield state.copyWith(faces: evt.faces);
      _updateTripStateIfNeeds();
      _detectGenders();
      _detectAgeRanges();
      return;
    }

    if (evt is TripStarted) {
      yield state.copyWith(trip: Trip.onTrip(state.faces));
      return;
    }

    if (evt is TripEnded) {
      yield state.copyWith(
        trip: const Trip.offTrip(),
        faces: const [],
        genders: const [],
        ageRanges: const [],
        keywords: const [],
      );
      return;
    }

    if (evt is GendersDetected) {
      if (state.trip.isOnTrip) {
        final distincted = [...state.genders, ...evt.genders].toSet().toList();
        yield state.copyWith(genders: distincted);
      }
      return;
    }

    if (evt is AgeRangesDetected) {
      if (state.trip.isOnTrip) {
        final distincted =
            [...state.ageRanges, ...evt.ageRanges].toSet().toList();
        yield state.copyWith(ageRanges: distincted);
      }
      return;
    }

    if (evt is KeywordsExtracted) {
      yield state.copyWith(keywords: evt.keywords);
      return;
    }

    if (evt is AppChangedState) {
      yield evt.state;
      return;
    }
  }

  @override
  close() async {
    _stopTrackingLocation();
    _stopFetchingAds();
    _stopTrackingMovement();

    _disposer.cancel();

    _permissionController.stop();
    _powerProvider.stop();

    _eventController.close();
    super.close();
  }

  _verifyPermission() {
    _permissionSubscription?.cancel();
    _permissionSubscription = _permissionController?.isAllowed$?.listen(
      (isAllowed) {
        add(Permitted(isAllowed));
      },
    );
    _permissionController?.start();
  }

  _verifyPower() {
    _powerSubscription?.cancel();
    _powerSubscription = _powerProvider?.isStrong$?.listen(
      (isStrong) {
        add(PowerSupplied(isStrong));
      },
    );

    _powerProvider?.start();
  }

  Stream<AppState> _startOrStopIfNeeds() async* {
    if (state.isStopped && state.isPermitted && state.isPowerStrong) {
      yield state.copyWith(
        isStarted: true,
        isTrackingLocation: true,
      );
      _startTrackingLocation();
      _startTrackingMovement();
    }

    if (state.isStarted && (state.isNotPermitted || state.isPowerWeak)) {
      yield state.copyWith(
        isStarted: false,
        isTrackingLocation: false,
        isFetchingAds: false,
      );
      _stopTrackingLocation();
      _stopFetchingAds();
      _stopTrackingMovement();
    }
  }

  StreamSubscription _trackLocationSubscription;

  _startTrackingLocation() {
    _trackLocationSubscription?.cancel();
    _trackLocationSubscription = _gpsController?.latLng$?.listen((latLng) {
      _adRepository?.changeLocation(latLng);
      add(Located(latLng));
    });
    _disposer.autoDispose(_trackLocationSubscription);
    _gpsController?.start();
  }

  _stopTrackingLocation() {
    _trackLocationSubscription?.cancel();
    _trackLocationSubscription = null;
    _gpsController?.stop();
  }

  StreamSubscription _trackMovementSubscription;

  _startTrackingMovement() {
    _trackMovementSubscription?.cancel();
    _trackMovementSubscription = _movementDetector?.isMoving$?.listen(
      (isMoving) {
        if (state.isMoving != isMoving) add(Moved(isMoving));
      },
    );
    _disposer.autoDispose(_trackMovementSubscription);
    _movementDetector?.start();
  }

  _stopTrackingMovement() {
    _trackMovementSubscription?.cancel();
    _trackMovementSubscription = null;
    _movementDetector?.stop();
  }

  StreamSubscription _adRepositorySubscription;

  _startFetchingAds() {
    _adRepositorySubscription = _adRepository?.ads$?.listen((ads) {
      if (!listEquals(state.readyAds.toList(), ads.toList()))
        add(ReadyAdsChanged(ads));
    });
    _disposer.autoDispose(_adRepositorySubscription);
    _adRepository?.start();
  }

  _stopFetchingAds() {
    _adRepositorySubscription?.cancel();
    _adRepository?.stop();
  }

  _detectGenders() async {
    for (final face in state.faces) {
      final gender = await _genderDetector?.detect(face);
      if (gender != null) add(GendersDetected([gender]));
    }
  }

  _detectAgeRanges() async {
    for (final face in state.faces) {
      final ageRange = await _ageDetector?.detect(face);
      if (ageRange != null) add(AgeRangesDetected([ageRange]));
    }
  }

  _updateTripStateIfNeeds() {
    if (state.isMoving && state.faces.isNotEmpty) {
      add(const TripStarted());
    }

    if (state.trip.isOnTrip && state.isNotMoving && state.faces.isEmpty) {
      add(const TripEnded());
    }
  }

  _capturePhotoIfNeeds() async {
    // 1. Stop capturing photo once on trip.
    // During the trip, use one Face Id was detected from the beginning.
    if (state.trip.isOnTrip) return;

    // 2. Vehicle is not moving then no need to detect faces.
    if (state.isNotMoving) return;

    final photo = await _cameraController?.capture();

    if (photo != null) add(PhotoCaptured(photo));
  }

  _detectFaces() async {
    final faces = await _faceDetector?.detect(state.capturedPhoto);
    if (faces != null) {
      if (faces.length == 0)
        add(const DetectedNoFace());
      else
        add(FacesDetected(faces));
    }
  }

  @override
  onEvent(AppEvent event) {
    _eventController.add(event);
    super.onEvent(event);
  }

  StreamController<AppEvent> _eventController;

  @visibleForTesting
  Stream<AppEvent> get event$ => _eventController.stream;

  final Disposer _disposer = Disposer();
}
