import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/supervisor/supervisor.dart';

/// Declare public interface that an SupervisorModule should expose
abstract class SupervisorModuleLocator {
  @provide
  Supervisor get supervisor;
}

/// A source of dependency provider for the injector.
@module
class SupervisorModule {
  @provide
  @singleton
  Supervisor supervisor(
    PowerProvider powerProvider,
    PermissionController permissionController,
    GpsController gpsController,
    AdScheduler adScheduler,
    AdRepository adRepository,
  ) {
    final Supervisor supervisor =
        SupervisorImpl(powerProvider.status, permissionController.status);

    // tell supervisor services it should manage.
    supervisor.addService(gpsController);
    supervisor.addService(adScheduler);
    supervisor.addService(adRepository);

    return supervisor;
  }
}
