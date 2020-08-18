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
    return TripDetectorImpl(
      powerProvider.state$,
      movementDetector.state$,
      faceDetector.faces$,
    );
  }

  @provide
  @singleton
  CameraController cameraController() {
    return CameraControllerImpl();
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
    return FaceDetectorImpl(cameraController.photo$);
  }

  @provide
  @singleton
  AgeDetector ageDetector(FaceDetector faceDetector) {
    return AgeDetectorImpl(faceDetector.faces$);
  }

  @provide
  @singleton
  GenderDetector genderDetector(FaceDetector faceDetector) {
    return GenderDetectorImpl(faceDetector.faces$);
  }

  @provide
  @singleton
  AreaDetector areaDetector(GpsController gpsController) {
    return AreaDetectorImpl(gpsController.latLng$);
  }
}
