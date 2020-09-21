import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import 'package:ad_bloc/base.dart';
import 'debugger.dart';

abstract class PermissionController {
  Stream<bool> get isAllowed$;

  /// All permissions that are managed.
  List<Permission> get permissions;

  start();
  stop();
}

/// Time in seconds that indicates how long it should elapse to repeatedly verify
/// permission statuses.
const _kRefreshSecs = 1;

class PermissionControllerImpl implements PermissionController {
  final BehaviorSubject<bool> subject;
  final PermissionDebugger debugger;

  PermissionControllerImpl({this.debugger})
      : subject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isAllowed$ => _isAllowed$ ??= subject.distinct();

  /// All permissions that are managed.
  ///
  /// [Permission.location] is used by implementers of [GpsController]
  /// [Permission.camera] is used by implementers of [CameraController]
  /// [Permission.microphone] is used by implementers of [MicController]
  /// [Permission.storage] is for storage components.
  List<Permission> get permissions => [
        Permission.location,
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ];

  start() {
    // immediately check permission when it's starting.
    // and schedule a timer to repeatedly verify it then.
    _verifyPermission();

    _timer = Timer.periodic(Duration(seconds: _kRefreshSecs), (_) {
      _verifyPermission();
    });
  }

  _verifyPermission() {
    if (debugger == null)
      _doVerifyPermission();
    else
      subject.add(debugger.isAllowed);
  }

  _doVerifyPermission() async {
    final statuses = await Future.wait(permissions.map((p) => p.status));

    for (final status in statuses) {
      // If once of service isn't pass the test, the controller is considered
      // being denied.
      if (!status.isGranted) {
        subject.add(false);
        return;
      }
    }

    // Once the permissions all granted, the timer must be cancel.
    _timer?.cancel();
    _timer = null;

    // even timer was canceled above, sometimes its callback still running on another
    // isolate and it canceled the stream. If so we need to double check before
    // closing the stream.
    if (!subject.isClosed) {
      // Once the permissions all granted, the stream must be closed.
      // Because once user revokes the permission, the app would be restarted
      // and the controller would be initialized again.
      subject.add(true);
      subject.close();
    }
  }

  stop() async {
    _timer?.cancel();
    _timer = null;
  }

  @visibleForTesting
  bool get isTimerStopped => _timer == null;

  /// A timer is set to periodically check permission status
  Timer _timer;

  /// [isAllowed$] backing field.
  Stream<bool> _isAllowed$;
}
