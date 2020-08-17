import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/movement_detector.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/on_trip/mic_controller.dart';
import 'package:ad_stream/src/modules/on_trip/speech_to_text.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';

import 'camera_controller.dart';

/// Declare public interface that an OnTripModule should expose
abstract class OnTripModuleLocator {
  @provide
  TripDetector get tripDetector;
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
      powerProvider.status$,
      movementDetector.status$,
      faceDetector.faces$,
    );
  }

  @provide
  SpeechToText speechToText(Stream<Audio> audio$) {
    return SpeechToTextImpl(audio$);
  }

  @provide
  @singleton
  FaceDetector faceDetector(CameraController cameraController) {
    return FaceDetectorImpl(cameraController.photo$);
  }
}
