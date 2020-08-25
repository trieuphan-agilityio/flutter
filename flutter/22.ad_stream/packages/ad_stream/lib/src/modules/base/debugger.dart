import 'package:flutter/foundation.dart';

/// A base class for all Debuggers.
abstract class Debugger {
  /// Get notification about the status of the debugger
  ValueListenable<bool> get isOn;

  /// Allow toggling debugger on the flight.
  toggle([bool newValue]);
}

mixin DebuggerMixin {
  /// Get notification about the status of the debugger.
  final ValueNotifier<bool> _isOn = ValueNotifier(false);

  ValueListenable<bool> get isOn => _isOn;

  toggle([bool newValue]) {
    _isOn.value = newValue ?? !_isOn.value;
  }
}
