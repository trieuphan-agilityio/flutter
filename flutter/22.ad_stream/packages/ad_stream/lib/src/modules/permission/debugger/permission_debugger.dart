import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionDebugger implements PermissionController {
  /// Current state of the debugger
  ValueListenable<PermissionDebuggerState> get debugState;

  /// Allow changing the state of debugger on the flight.
  /// While enabled, the debugger will drive the status stream for the controller.
  setDebugState(PermissionDebuggerState newValue);
}

class PermissionDebuggerImpl implements PermissionDebugger {
  /// Allow using a fallback [PermissionController] when disable debugger.
  /// If null, the status stream is empty.
  final PermissionController _delegate;

  PermissionDebuggerImpl(this._delegate)
      : _state$Controller = BehaviorSubject<PermissionState>(),
        _state$Switcher = StreamController<Stream<PermissionState>>() {
    // set up listeners of notifier
    debugState.addListener(() {
      if (debugState.value == PermissionDebuggerState.off) {
        _state$Switcher.add(_delegate.state$);
      } else {
        _state$Switcher.add(_state$Controller.stream);
        if (debugState.value == PermissionDebuggerState.allow) {
          _state$Controller.add(PermissionState.allowed);
        }
        if (debugState.value == PermissionDebuggerState.deny) {
          _state$Controller.add(PermissionState.denied);
        }
      }
    });

    // set up initial values
    _state$Controller.add(PermissionState.allowed);
    _state$Switcher.add(_state$Controller.stream);
  }

  /// Keep the enabled status of the debugger.
  final ValueNotifier<PermissionDebuggerState> debugState =
      ValueNotifier(PermissionDebuggerState.allow);

  @override
  setDebugState(PermissionDebuggerState newValue) {
    assert(newValue != null, 'newValue must not be null.');
    debugState.value = newValue;
  }

  final BehaviorSubject<PermissionState> _state$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isOn] flag.
  final StreamController<Stream<PermissionState>> _state$Switcher;

  Stream<PermissionState> get state$ {
    return _state$ ??= _state$Switcher.stream.switchLatest();
  }

  /// A cache instance of [state$] stream.
  Stream<PermissionState> _state$;
}

class PermissionDebuggerState {
  final int value;
  final String name;

  const PermissionDebuggerState(this.value, this.name);

  static const PermissionDebuggerState off = PermissionDebuggerState(1, 'Off');
  static const PermissionDebuggerState allow =
      PermissionDebuggerState(2, 'Always allowed');
  static const PermissionDebuggerState deny =
      PermissionDebuggerState(3, 'Always denied');

  static const List<PermissionDebuggerState> values = [
    PermissionDebuggerState.off,
    PermissionDebuggerState.allow,
    PermissionDebuggerState.deny,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionDebuggerState &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
