import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class PowerDebugger implements Debugger, PowerProvider {
  /// Set WEAK status
  weak();

  /// Set STRONG status
  strong();
}

class PowerDebuggerImpl with DebuggerMixin implements PowerDebugger {
  /// Allow using a fallback [PowerProvider] when disable debugger.
  /// If null, the status stream is empty.
  final PowerProvider _delegate;

  PowerDebuggerImpl(this._delegate)
      : _state$Controller = BehaviorSubject<PowerState>(),
        _state$Switcher = BehaviorSubject<Stream<PowerState>>() {
    // set up listeners for the notifier
    isOn.addListener(() {
      if (isOn.value)
        _state$Switcher.add(_state$Controller.stream);
      else
        _state$Switcher.add(_delegate.state$);
    });

    // set up initial values
    _state$Controller.add(PowerState.strong);
    _state$Switcher.add(_state$Controller.stream);
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
    toggle(true);
    _state$Controller.add(PowerState.weak);
  }

  strong() {
    toggle(true);
    _state$Controller.add(PowerState.strong);
  }
}
