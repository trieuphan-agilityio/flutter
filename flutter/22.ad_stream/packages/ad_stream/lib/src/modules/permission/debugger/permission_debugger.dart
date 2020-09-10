import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger_state.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionDebugger implements PermissionController {
  /// Expose [PermissionController] that is wrapped by this debugger.
  PermissionController get delegate;

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

  PermissionController get delegate => _delegate;

  /// Persist and restore debugger state from preference storage.
  final PrefStoreWriting _prefStore;

  PermissionDebuggerImpl(this._delegate, this._prefStore)
      : _state$Controller = BehaviorSubject<PermissionState>(),
        _state$Switcher = BehaviorSubject<Stream<PermissionState>>() {
    // Turn off debugger by default
    _changeForOffState();

    // set up listeners of notifier
    debugState.addListener(() {
      if (debugState.value == PermissionDebuggerState.off) {
        _changeForOffState();
      } else if (debugState.value == PermissionDebuggerState.allow) {
        _changeForAllowedState();
      } else if (debugState.value == PermissionDebuggerState.deny) {
        _changeForDeniedState();
      }
    });
  }

  _changeForAllowedState() {
    _state$Switcher.add(_state$Controller.stream);
    _state$Controller.add(PermissionState.allowed);
  }

  _changeForOffState() {
    _state$Switcher.add(_delegate.state$);
  }

  _changeForDeniedState() {
    _state$Switcher.add(_state$Controller.stream);
    _state$Controller.add(PermissionState.denied);
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

  PermissionState get state {
    if (debugState.value == PermissionDebuggerState.allow) {
      return PermissionState.allowed;
    } else if (debugState.value == PermissionDebuggerState.deny) {
      return PermissionState.denied;
    } else if (debugState.value == PermissionDebuggerState.off) {
      return _delegate.state;
    }
    throw StateError('${debugState.value} is not support');
  }

  Stream<PermissionState> get state$ {
    return _state$ ??= _state$Switcher.stream.switchLatest();
  }

  List<Permission> get permissions => _delegate.permissions;

  @override
  start() async {
    super.start();

    // Restore debugger state from storage
    final persistedDebugState = PermissionDebuggerState.stateByValue(
      _prefStore.getInt(_kPermissionDebuggerState),
    );
    if (persistedDebugState != null) {
      debugState.value = persistedDebugState;
    }

    _delegate.start();
  }

  @override
  stop() async {
    super.stop();
    _delegate.stop();
  }

  /// A cache instance of [state$] stream.
  Stream<PermissionState> _state$;
}
