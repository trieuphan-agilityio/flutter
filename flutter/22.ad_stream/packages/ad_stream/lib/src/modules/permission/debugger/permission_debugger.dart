import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
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
  final StreamController<PermissionState> _state$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isEnabled] flag.
  final StreamController<Stream<PermissionState>> _state$Switcher;

  /// Allow using a fallback [PermissionController] when disable debugger.
  /// If null, the status stream is empty.
  final PermissionController _delegate;

  PermissionDebuggerImpl(this._delegate)
      : _state$Controller =
            BehaviorSubject<PermissionState>.seeded(PermissionState.ALLOWED),
        _state$Switcher = StreamController<Stream<PermissionState>>() {
    isEnabled = true;
  }

  Stream<PermissionState> get state$ {
    return _state$ ??= _state$Switcher.stream.switchLatest();
  }

  bool get isEnabled => _isEnabled;

  set isEnabled(bool newValue) {
    _isEnabled = newValue;
    if (_isEnabled)
      _state$Switcher.add(_state$Controller.stream);
    else
      _state$Switcher.add(_delegate.state$);
  }

  allow() {
    _state$Controller.add(PermissionState.ALLOWED);
  }

  deny() {
    _state$Controller.add(PermissionState.DENIED);
  }

  /// Keep the enabled status of the debugger.
  bool _isEnabled;

  /// A cache instance of status stream.
  Stream<PermissionState> _state$;
}
