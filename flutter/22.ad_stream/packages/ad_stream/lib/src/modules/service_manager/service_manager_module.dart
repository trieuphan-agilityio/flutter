import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/ad/ad_scheduler.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

/// Declare public interface that an SupervisorModule should expose
abstract class ServiceManagerModuleLocator {
  @provide
  ServiceManager get serviceManager;
}

/// A source of dependency provider for the injector.
@module
class ServiceManagerModule {
  @provide
  @singleton
  ServiceManager serviceManager(
    PowerProvider powerProvider,
    PermissionController permissionController,
    GpsController gpsController,
    AdScheduler adScheduler,
    AdRepository adRepository,
  ) {
    final ServiceManager serviceManager =
        ServiceManagerImpl(powerProvider.status, permissionController.status);

    // tell service manager services it should manage.
    serviceManager.addService(gpsController);
    serviceManager.addService(adScheduler);
    serviceManager.addService(adRepository);

    return serviceManager;
  }
}
