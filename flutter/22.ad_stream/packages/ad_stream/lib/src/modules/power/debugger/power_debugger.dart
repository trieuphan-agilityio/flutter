import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class PowerDebugger implements Debugger, PowerProvider {
  /// Set WEAK status
  weak();

  /// Set STRONG status
  strong();
}

class PowerDebuggerImpl implements PowerDebugger {
  /// Allow using a fallback [PowerProvider] when disable debugger.
  /// If null, the status stream is empty.
  final PowerProvider _delegate;

  PowerDebuggerImpl(this._delegate)
      : _state$Controller = BehaviorSubject<PowerState>(),
        _state$Switcher = BehaviorSubject<Stream<PowerState>>() {
    // set up listeners for the notifier
    _isOn.addListener(() {
      if (_isOn.value)
        _state$Switcher.add(_state$Controller.stream);
      else
        _state$Switcher.add(_delegate.state$);
    });

    // set up initial values
    _state$Controller.add(PowerState.strong);
    _state$Switcher.add(_state$Controller.stream);
  }

  /// Keep the enabled status of the debugger.
  final ValueNotifier<bool> _isOn = ValueNotifier(true);

  /// While enabled, the debugger will drive the status stream for the controller.
  /// By invoking [weak] or [strong] the status would be updated accordingly.
  ValueListenable<bool> get isOn => _isOn;

  /// Allow turning on/off debugger on the flight.
  toggle([bool newValue]) {
    _isOn.value = newValue ?? !_isOn.value;
  }

  final BehaviorSubject<PowerState> _state$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isOn] flag.
  final BehaviorSubject<Stream<PowerState>> _state$Switcher;

  /// A cache instance of [status$] stream.
  Stream<PowerState> _state$;

  @override
  Stream<PowerState> get state$ {
    return _state$ ??= _state$Switcher.stream.switchLatest();
  }

  weak() {
    _state$Controller.add(PowerState.weak);
  }

  strong() {
    _state$Controller.add(PowerState.strong);
  }
}
