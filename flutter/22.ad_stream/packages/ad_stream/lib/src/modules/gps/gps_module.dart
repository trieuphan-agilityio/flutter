import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:ad_stream/src/modules/gps/movement_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import 'gps_controller.dart';

/// Declare public interface that an GpsModule should expose
abstract class GpsModuleLocator {
  @provide
  GpsController get gpsController;

  @provide
  GpsDebugger get gpsDebugger;

  @provide
  MovementDetector get movementDetector;
}

/// A source of dependency provider for the injector.
/// It contains Gps related services, such as Battery.
@module
class GpsModule {
  @provide
  @singleton
  GpsController gpsController(
    ServiceManager serviceManager,
    GpsDebugger gpsDebugger,
  ) {
    final geolocator = Geolocator();
    final defaultGpsOptions = GpsOptions(accuracy: GpsAccuracy.best);
    final gpsOptions$Controller =
        BehaviorSubject<GpsOptions>.seeded(defaultGpsOptions);

    final gpsController = GpsControllerImpl(
      gpsOptions$Controller.stream,
      geolocator,
      debugger: GpsDebuggerImpl(),
    );
    gpsController.listen(serviceManager.status$);

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    gpsController.latLng$.listen((latLng) {
      return Log.info(
          'GpsController ${stopwatch.elapsedMilliseconds}: $latLng');
    });

    return gpsController;
  }

  @provide
  @singleton
  GpsDebugger gpsDebugger() {
    return GpsDebuggerImpl();
  }

  @provide
  @singleton
  MovementDetector movementDetector(GpsController gpsController) {
    final movementDetector = MovementDetectorImpl(gpsController.latLng$);
    movementDetector.listen(gpsController.status$);
    return movementDetector;
  }
}
