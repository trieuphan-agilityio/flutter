import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:inject/inject.dart';

/// Declare public interface that an PermissionServices should expose
abstract class PermissionServiceLocator {
  @provide
  PermissionController get permissionController;
}

/// A source of dependency provider for the injector.
@module
class PermissionServices {
  @provide
  @singleton
  PermissionController permissionController() {
    return AlwaysAllowPermissionController();
  }
}
