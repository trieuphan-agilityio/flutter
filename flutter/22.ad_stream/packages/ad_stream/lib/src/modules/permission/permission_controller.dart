import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionController implements Service {
  /// Keep a reference to the last state of [state$].
  PermissionState get state;

  /// Stream state of all managed permissions.
  /// There are two states: all granted or one-or-more denied
  Stream<PermissionState> get state$;

  /// All permissions that are managed.
  List<Permission> get permissions;
}

/// Time in seconds that indicates how long it should elapse to repeatedly verify
/// permission statuses.
const _kRefreshSecs = 1;

class PermissionControllerImpl
    with ServiceMixin
    implements PermissionController {
  final BehaviorSubject<PermissionState> _stateSubject;

  PermissionControllerImpl()
      : _stateSubject = BehaviorSubject<PermissionState>();

  PermissionState get state => _stateSubject.value;

  Stream<PermissionState> get state$ =>
      _state$ ??= _stateSubject.stream.distinct();

  List<Permission> get permissions => [
        Permission.location,
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ];

  @override
  Future<void> start() {
    super.start();

    // immediately check permission when it's starting.
    // and schedule a timer to repeatedly verify it then.
    _verifyPermission();

    _timer = Timer.periodic(Duration(seconds: _kRefreshSecs), (_) {
      _verifyPermission();
    });
    return null;
  }

  _verifyPermission() async {
    final statuses = await Future.wait(permissions.map((p) => p.status));

    for (final status in statuses) {
      // If once of service isn't pass the test, the controller is considered
      // being denied.
      if (!status.isGranted) {
        _stateSubject.add(PermissionState.denied);
        return;
      }
    }

    // Once the permissions all granted, the timer must be cancel.
    _timer?.cancel();
    _timer = null;

    // even timer was canceled above, sometimes its callback still running on another
    // isolate and it canceled the stream. If so we need to double check before
    // closing the stream.
    if (!_stateSubject.isClosed) {
      // Once the permissions all granted, the stream must be closed.
      // Because once user revokes the permission, the app would be restarted
      // and the controller would be initialized again.
      _stateSubject.add(PermissionState.allowed);
      _stateSubject.close();
    }
  }

  @override
  Future<void> stop() {
    super.stop();

    _timer?.cancel();
    _timer = null;

    return null;
  }

  @visibleForTesting
  bool get isTimerStopped => _timer == null;

  /// A timer is set to periodically check permission status
  Timer _timer;

  /// [state$] backing field.
  Stream<PermissionState> _state$;
}
