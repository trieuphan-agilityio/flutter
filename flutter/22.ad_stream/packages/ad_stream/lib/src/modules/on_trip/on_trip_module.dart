import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/gps/movement_detector.dart';
import 'package:ad_stream/src/modules/on_trip/age_detector.dart';
import 'package:ad_stream/src/modules/on_trip/area_detector.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/on_trip/gender_detector.dart';
import 'package:ad_stream/src/modules/on_trip/keyword_detector.dart';
import 'package:ad_stream/src/modules/on_trip/mic_controller.dart';
import 'package:ad_stream/src/modules/on_trip/speech_to_text.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

import 'camera_controller.dart';

/// Declare public interface that an OnTripModule should expose
abstract class OnTripModuleLocator {
  @provide
  TripDetector get tripDetector;

  @provide
  CameraController get cameraController;

  @provide
  MicController get micController;

  @provide
  SpeechToText get speechToText;

  @provide
  KeywordDetector get keywordDetector;

  @provide
  FaceDetector get faceDetector;

  @provide
  AgeDetector get ageDetector;

  @provide
  GenderDetector get genderDetector;

  @provide
  AreaDetector get areaDetector;
}

/// A source of dependency provider for the injector.
@module
class OnTripModule {
  @provide
  @singleton
  TripDetector tripDetector(
    PowerProvider powerProvider,
    MovementDetector movementDetector,
    FaceDetector faceDetector,
  ) {
    final tripDetector = TripDetectorImpl(
      powerProvider.state$,
      movementDetector.state$,
      faceDetector.faces$,
    );

    // bind lifecycle of [TripDetector] to [MovementDetector].
    tripDetector.listen(movementDetector.status$);

    return tripDetector;
  }

  @provide
  @singleton
  CameraController cameraController(
    ServiceManager serviceManager,
    Config config,
  ) {
    final cameraController = CameraControllerImpl(config);
    cameraController.listen(serviceManager.status$);
    return cameraController;
  }

  @provide
  @singleton
  MicController micController() {
    return MicControllerImpl();
  }

  @provide
  @singleton
  SpeechToText speechToText(MicController micController) {
    return SpeechToTextImpl(micController.audio$);
  }

  @provide
  @singleton
  KeywordDetector keywordDetector(SpeechToText speechToText) {
    return KeywordDetectorImpl(speechToText.text$);
  }

  @provide
  @singleton
  FaceDetector faceDetector(CameraController cameraController) {
    final faceDetector = FaceDetectorImpl(cameraController.photo$);
    faceDetector.listen(cameraController.status$);
    return faceDetector;
  }

  @provide
  @singleton
  AgeDetector ageDetector(
    TripDetector tripDetector,
    FaceDetector faceDetector,
  ) {
    final ageDetector = AgeDetectorImpl(faceDetector.faces$);
    ageDetector.listenToTripState(tripDetector.state$);
    return ageDetector;
  }

  @provide
  @singleton
  GenderDetector genderDetector(
    TripDetector tripDetector,
    FaceDetector faceDetector,
  ) {
    final genderDetector = GenderDetectorImpl(faceDetector.faces$);
    genderDetector.listenToTripState(tripDetector.state$);
    return genderDetector;
  }

  @provide
  @singleton
  AreaDetector areaDetector(GpsController gpsController) {
    return AreaDetectorImpl(gpsController.latLng$);
  }
}
