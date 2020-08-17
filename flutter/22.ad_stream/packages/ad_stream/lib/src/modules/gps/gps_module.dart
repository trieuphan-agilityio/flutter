import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/movement_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

import 'gps_controller.dart';

/// Declare public interface that an GpsModule should expose
abstract class GpsModuleLocator {
  @provide
  GpsController get gpsController;

  @provide
  MovementDetector get movementDetector;
}

/// A source of dependency provider for the injector.
/// It contains Gps related services, such as Battery.
@module
class GpsModule {
  @provide
  @singleton
  GpsController gpsController(ServiceManager serviceManager, Config config) {
    final gpsController = FixedGpsController(config);
    gpsController.listen(serviceManager.status$);
    return gpsController;
  }

  @provide
  @singleton
  MovementDetector movementDetector(GpsController gpsController) {
    return MovementDetectorImpl(gpsController.latLng$);
  }
}
