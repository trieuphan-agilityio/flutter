import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service_manager.dart';

/// Declare public interface that an ServiceManagerModule should expose
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
  ) {
    return ServiceManagerImpl(
      powerProvider.status$,
      permissionController.status$,
    );
  }
}
