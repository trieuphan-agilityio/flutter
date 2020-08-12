import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_status.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionDebugger implements PermissionController {
  /// Allow toggling debugger on the flight.
  /// While enabled, the debugger will drive the status stream for the controller.
  /// By invoking [allow] or [deny] the status would be updated accordingly.
  bool isEnabled;

  /// Set ALLOWED status
  allow();

  /// Set DENIED status
  deny();
}

class PermissionDebuggerImpl implements PermissionDebugger {
  final StreamController<PermissionStatus> _status$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isEnabled] flag.
  final StreamController<Stream<PermissionStatus>> _status$Switcher;

  /// Allow using a fallback [PermissionController] when disable debugger.
  /// If null, the status stream is empty.
  final PermissionController _delegate;

  PermissionDebuggerImpl(this._delegate)
      : _status$Controller =
            BehaviorSubject<PermissionStatus>.seeded(PermissionStatus.ALLOWED),
        _status$Switcher = StreamController<Stream<PermissionStatus>>() {
    isEnabled = true;
  }

  Stream<PermissionStatus> get status$ {
    return _status$ ??= _status$Switcher.stream.switchLatest();
  }

  bool get isEnabled => _isEnabled;

  set isEnabled(bool newValue) {
    _isEnabled = newValue;
    if (_isEnabled)
      _status$Switcher.add(_status$Controller.stream);
    else
      _status$Switcher.add(_delegate.status$);
  }

  allow() {
    _status$Controller.add(PermissionStatus.ALLOWED);
  }

  deny() {
    _status$Controller.add(PermissionStatus.DENIED);
  }

  /// Keep the enabled status of the debugger.
  bool _isEnabled;

  /// A cache instance of status stream.
  Stream<PermissionStatus> _status$;
}
