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
    ServiceManager serviceManager,
    MovementDetector movementDetector,
    FaceDetector faceDetector,
  ) {
    final tripDetector = TripDetectorImpl(
      movementDetector.state$,
      faceDetector.faces$,
    );
    tripDetector.listenTo(serviceManager.status$);
    faceDetector.attachTripState(tripDetector.state$);
    return tripDetector;
  }

  @provide
  @singleton
  CameraController cameraController(Config config) {
    return CameraControllerImpl(config);
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
  FaceDetector faceDetector(
    MovementDetector movementDetector,
    CameraController cameraController,
  ) {
    return FaceDetectorImpl(movementDetector.state$, cameraController.photo$);
  }

  @provide
  @singleton
  AgeDetector ageDetector() {
    return AgeDetectorImpl();
  }

  @provide
  @singleton
  GenderDetector genderDetector() {
    return GenderDetectorImpl();
  }

  @provide
  @singleton
  AreaDetector areaDetector(GpsController gpsController, Config config) {
    final areaDetector = AreaDetectorImpl(gpsController.latLng$, config);
    areaDetector.listenTo(gpsController.status$);
    return areaDetector;
  }
}
