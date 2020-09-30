import 'dart:async';

import 'package:ad_bloc/base.dart';
import 'package:permission_handler/permission_handler.dart';

import 'debugger_builder.dart';
import 'service.dart';

abstract class PermissionController implements Service {
  Stream<bool> get isAllowed$;

  /// All permissions that are managed.
  List<Permission> get permissions;
}

/// Time in seconds that indicates how long it should elapse to repeatedly verify
/// permission statuses.
const _kRefreshSecs = 1;

class PermissionControllerImpl
    with ServiceMixin
    implements PermissionController {
  PermissionControllerImpl({this.debugger})
      : controller = StreamController<bool>.broadcast() {
    backgroundTask = ServiceTask(_verifyPermission, _kRefreshSecs);
  }

  final StreamController<bool> controller;
  final PermissionDebugger debugger;

  Stream<bool> get isAllowed$ => _isAllowed$ ??= controller.stream.distinct();

  /// All permissions that are managed.
  ///
  /// [Permission.locationWhenInUse] is used by implementers of [GpsController]
  /// [Permission.camera] is used by implementers of [CameraController]
  /// [Permission.microphone] is used by implementers of [MicController]
  /// [Permission.storage] is for storage components.
  List<Permission> get permissions => [
        Permission.locationWhenInUse,
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ];

  @override
  start() async {
    super.start();

    // immediately check permission when it's starting.
    // and schedule a timer to repeatedly verify it then.
    backgroundTask.runTask();
  }

  _verifyPermission() {
    if (debugger == null)
      _doVerifyPermission();
    else
      controller.add(debugger.isAllowed);
  }

  _doVerifyPermission() async {
    final statuses = await Future.wait(permissions.map((p) => p.status));

    for (final status in statuses) {
      // If once of service isn't pass the test, the controller is considered
      // being denied.
      if (!status.isGranted) {
        controller.add(false);
        return;
      }
    }

    // all permission have been granted
    controller.add(true);
  }

  /// [isAllowed$] backing field.
  Stream<bool> _isAllowed$;
}
