import 'package:ad_stream/base.dart';
import 'package:ad_stream/config.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/gps/movement_detector.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';
import 'package:geolocator/geolocator.dart';

import 'adapter_for_geolocator.dart';
import 'gps_controller.dart';
import 'gps_options_provider.dart';

/// Declare public interface that an GpsModule should expose
abstract class GpsModuleLocator {
  @provide
  GpsController get gpsController;

  @provide
  GpsDebugger get gpsDebugger;

  @provide
  GpsOptionsProvider get gpsOptionsProvider;

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
    PermissionDebugger permissionDebugger,
    GpsDebugger gpsDebugger,
    GpsOptionsProvider gpsOptionsProvider,
  ) async {
    final gpsAdapter = AdapterForGeolocator(Geolocator(), permissionDebugger);

    // The GpsOptions is passed to a stream so that it can be changed depend on
    // the current state of other component. E.g On trip and off trip may cause
    // different GpsOptions.
    final gpsController = GpsControllerImpl(
      gpsOptionsProvider.gpsOptions$,
      gpsAdapter,
      debugger: gpsDebugger,
    );

    gpsController.listenTo(serviceManager.status$);

    /*
    We can listen to the gps controller here to record debug route.
    E.g:

    final stopwatch = Stopwatch();
    gpsController.latLng$.listen((e) {
      Log.info('RR: ${stopwatch.elapsedMilliseconds},${e.lat},${e.lng}');
    });
    stopwatch.start();
    */

    return gpsController;
  }

  @provide
  @singleton
  GpsDebugger gpsDebugger() {
    return GpsDebuggerImpl();
  }

  @provide
  @singleton
  GpsOptionsProvider gpsOptionsProvider(GpsConfigProvider gpsConfigProvider) {
    return GpsOptionsProviderImpl(gpsConfigProvider);
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
