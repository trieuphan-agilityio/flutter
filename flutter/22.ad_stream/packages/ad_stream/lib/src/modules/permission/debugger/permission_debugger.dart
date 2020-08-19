import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionDebugger implements PermissionController {
  /// Allow toggling debugger on the flight.
  /// While enabled, the debugger will drive the status stream for the controller.
  /// By invoking [allow] or [deny] the status would be updated accordingly.
  ValueListenable<bool> get isOn;

  /// Turn on/off the debugger
  toggle([bool newValue]);

  /// Set ALLOWED status
  allow();

  /// Set DENIED status
  deny();
}

class PermissionDebuggerImpl implements PermissionDebugger {
  /// Allow using a fallback [PermissionController] when disable debugger.
  /// If null, the status stream is empty.
  final PermissionController _delegate;

  PermissionDebuggerImpl(this._delegate)
      : _state$Controller = BehaviorSubject<PermissionState>(),
        _state$Switcher = StreamController<Stream<PermissionState>>() {
    // set up listeners of notifier
    _isOn.addListener(() {
      if (_isOn.value)
        _state$Switcher.add(_state$Controller.stream);
      else
        _state$Switcher.add(_delegate.state$);
    });

    // set up initial values
    _state$Controller.add(PermissionState.allowed);
    _state$Switcher.add(_state$Controller.stream);
  }

  /// Keep the enabled status of the debugger.
  final ValueNotifier<bool> _isOn = ValueNotifier(true);

  ValueListenable<bool> get isOn => _isOn;

  toggle([bool newValue]) {
    _isOn.value = newValue ?? !_isOn.value;
  }

  final StreamController<PermissionState> _state$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isOn] flag.
  final StreamController<Stream<PermissionState>> _state$Switcher;

  /// A cache instance of [state$] stream.
  Stream<PermissionState> _state$;

  Stream<PermissionState> get state$ {
    return _state$ ??= _state$Switcher.stream.switchLatest();
  }

  allow() {
    _state$Controller.add(PermissionState.allowed);
  }

  deny() {
    _state$Controller.add(PermissionState.denied);
  }
}
