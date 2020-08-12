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
  final StreamController<PowerStatus> _status$Controller;

  /// Use this controller to switch to the corresponding status stream when
  /// toggle [isEnabled] flag.
  final StreamController<Stream<PowerStatus>> _status$Switcher;

  /// Allow using a fallback [PowerProvider] when disable debugger.
  /// If null, the status stream is empty.
  final PowerProvider _delegate;

  PowerDebuggerImpl(this._delegate)
      : _status$Controller =
            BehaviorSubject<PowerStatus>.seeded(PowerStatus.STRONG),
        _status$Switcher = StreamController<Stream<PowerStatus>>() {
    isEnabled = true;
  }

  @override
  Stream<PowerStatus> get status$ {
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

  weak() {
    _status$Controller.add(PowerStatus.WEAK);
  }

  strong() {
    _status$Controller.add(PowerStatus.STRONG);
  }

  /// Keep the enabled status of the debugger.
  bool _isEnabled;

  /// A cache instance of status stream.
  Stream<PowerStatus> _status$;
}
