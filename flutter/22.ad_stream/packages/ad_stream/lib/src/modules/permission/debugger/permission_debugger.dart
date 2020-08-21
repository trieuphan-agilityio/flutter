import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger_state.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionDebugger implements PermissionController {
  /// Current state of the debugger
  ValueListenable<PermissionDebuggerState> get debugState;

  /// Allow changing the state of debugger on the flight.
  /// While enabled, the debugger will drive the status stream for the controller.
  setDebugState(PermissionDebuggerState newValue);
}

/// The key of debug state value that is persisted in the preference storage.
const _kPermissionDebuggerState = 'me.sangdong/PermissionDebuggerState';

class PermissionDebuggerImpl with ServiceMixin implements PermissionDebugger {
  /// Allow using a fallback [PermissionController] when disable debugger.
  /// If null, the status stream is empty.
  final PermissionController _delegate;

  final PrefStoreWriting _prefStore;

  PermissionDebuggerImpl(this._delegate, this._prefStore)
      : _state$Controller = BehaviorSubject<PermissionState>(),
        _state$Switcher = BehaviorSubject<Stream<PermissionState>>() {
    // Set up initial values
    // 1. If debugger is enabled, it will produce Allowed event
    _state$Controller.add(PermissionState.allowed);

    // 2. Turn off debugger by default
    _state$Switcher.add(_delegate.state$);

    final persistedDebugState = PermissionDebuggerState.stateByValue(
      _prefStore.getInt(_kPermissionDebuggerState),
    );
    // 3. Set turn off state
    debugState.value = persistedDebugState ?? PermissionDebuggerState.off;

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
  }

  /// Get notification about the state of the debugger.
  ///
  /// Default state is [PermissionDebuggerState.off]
  final ValueNotifier<PermissionDebuggerState> debugState =
      ValueNotifier(PermissionDebuggerState.off);

  setDebugState(PermissionDebuggerState newValue) {
    assert(newValue != null, 'newValue must not be null.');

    // save to store
    _prefStore.setInt(_kPermissionDebuggerState, newValue.value);

    // notify its listener
    debugState.value = newValue;
  }

  final BehaviorSubject<PermissionState> _state$Controller;

  /// Use this controller to switch to the corresponding status stream
  final BehaviorSubject<Stream<PermissionState>> _state$Switcher;

  Stream<PermissionState> get state$ {
    return _state$ ??= _state$Switcher.stream.switchLatest();
  }

  List<Permission> get permissions => _delegate.permissions;

  @override
  Future<void> start() {
    super.start();
    _delegate.start();
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _delegate.stop();
    return null;
  }

  /// A cache instance of [state$] stream.
  Stream<PermissionState> _state$;
}
