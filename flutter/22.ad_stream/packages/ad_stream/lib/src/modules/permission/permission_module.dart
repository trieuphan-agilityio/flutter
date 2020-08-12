import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:inject/inject.dart';

/// Declare public interface that an PermissionServices should expose
abstract class PermissionModuleLocator {
  @provide
  PermissionController get permissionController;

  @provide
  PermissionDebugger get permissionDebugger;
}

/// A source of dependency provider for the injector.
@module
class PermissionModule {
  @provide
  @singleton
  PermissionController permissionController(PermissionDebugger debugger) {
    return debugger;
  }

  @provide
  @singleton
  PermissionDebugger permissionDebugger() {
    return PermissionDebuggerImpl(PermissionControllerImpl());
  }
}
