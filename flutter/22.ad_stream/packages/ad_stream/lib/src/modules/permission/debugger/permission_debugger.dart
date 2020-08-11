import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_status.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionDebugger implements PermissionController {
  /// Allow toggling debugger on the flight.
  bool isEnabled;

  /// Set ALLOWED status
  allow();

  /// Set DENIED status
  deny();
}

class PermissionDebuggerImpl implements PermissionDebugger {
  final StreamController<PermissionStatus> _controller;

  /// Allow using a fallback [PermissionController] when disable debugger.
  /// If null, the status stream is empty.
  final PermissionController _delegate;

  PermissionDebuggerImpl({PermissionController delegate})
      : _delegate = delegate,
        _controller =
            BehaviorSubject<PermissionStatus>.seeded(PermissionStatus.ALLOWED);

  /// A cache instance of status stream.
  Stream<PermissionStatus> _status$;

  @override
  Stream<PermissionStatus> get status$ {
    return _status$ ??= _controller.stream.combineLatest(
      _delegate?.status$ ?? Stream.empty(),
      (debugStatus, status) => isEnabled ? debugStatus : status,
    );
  }

  bool isEnabled = true;

  allow() {
    _controller.add(PermissionStatus.ALLOWED);
  }

  deny() {
    _controller.add(PermissionStatus.DENIED);
  }
}
