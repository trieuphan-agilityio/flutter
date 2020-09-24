import 'package:meta/meta.dart';

class CameraConfig {
  /// Time in seconds indicates how frequently [CameraController] captures the
  /// photo of passenger on the trip.
  final int captureInterval;

  CameraConfig({@required this.captureInterval});
}

abstract class CameraConfigProvider {
  CameraConfig get cameraConfig;
  Stream<CameraConfig> get cameraConfig$;
}
