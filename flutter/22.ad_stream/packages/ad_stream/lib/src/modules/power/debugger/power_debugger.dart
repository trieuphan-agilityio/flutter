import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class PowerDebugger implements PowerProvider {
  /// Allow toggling debugger on the flight.
  /// While enabled, the debugger will drive the status stream for the controller.
  /// By invoking [weak] or [strong] the status would be updated accordingly.
  bool isEnabled;

  /// Set WEAK status
  weak();

  /// Set STRONG status
  strong();
}

class PowerDebuggerImpl implements PowerDebugger {
  final StreamController<PowerState> _state$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isEnabled] flag.
  final StreamController<Stream<PowerState>> _state$Switcher;

  /// Allow using a fallback [PowerProvider] when disable debugger.
  /// If null, the status stream is empty.
  final PowerProvider _delegate;

  PowerDebuggerImpl(this._delegate)
      : _state$Controller =
            BehaviorSubject<PowerState>.seeded(PowerState.strong),
        _state$Switcher = StreamController<Stream<PowerState>>() {
    isEnabled = true;
  }

  @override
  Stream<PowerState> get state$ {
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

  weak() {
    _state$Controller.add(PowerState.weak);
  }

  strong() {
    _state$Controller.add(PowerState.strong);
  }

  /// Keep the enabled status of the debugger.
  bool _isEnabled;

  /// A cache instance of [status$] stream.
  Stream<PowerState> _state$;
}
