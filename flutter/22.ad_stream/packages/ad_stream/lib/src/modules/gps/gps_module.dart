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
  @asynchronous
  Future<GpsController> gpsController(
    ServiceManager serviceManager,
    GpsDebugger gpsDebugger,
    Config config,
  ) async {
    final geolocator = Geolocator();

    // The GpsOptions is passed to a stream so that it can be changed depend on
    // the current state of other component. E.g On trip and off trip may cause
    // different GpsOptions.

    // FIXME This causes many frames are skipped on initialization.
    //       For now use @asynchronous annotation to avoid block main thread.
    // ignore: close_sinks
    final gpsOptions$Controller =
        BehaviorSubject<GpsOptions>.seeded(config.defaultGpsOptions);

    final gpsController = GpsControllerImpl(
      gpsOptions$Controller.stream,
      geolocator,
      debugger: gpsDebugger,
    );

    gpsController.listenTo(serviceManager.status$);

    return gpsController;
  }

  @provide
  @singleton
  GpsDebugger gpsDebugger() {
    return GpsDebuggerImpl();
  }

  @provide
  @singleton
  MovementDetector movementDetector(
    ServiceManager serviceManager,
    GpsController gpsController,
  ) {
    final movementDetector = MovementDetectorImpl(gpsController.latLng$);
    movementDetector.listenTo(serviceManager.status$);
    return movementDetector;
  }
}
