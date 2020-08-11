import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class PowerDebugger implements PowerProvider {
  /// Allow toggling debugger on the flight.
  bool isEnabled;

  /// Set WEAK status
  weak();

  /// Set STRONG status
  strong();
}

class PowerDebuggerImpl implements PowerDebugger {
  final StreamController<PowerStatus> _controller;

  /// Allow using a fallback [PowerProvider] when disable debugger.
  /// If null, the status stream is empty.
  final PowerProvider _delegate;

  PowerDebuggerImpl({PowerProvider delegate})
      : _delegate = delegate,
        _controller = BehaviorSubject<PowerStatus>.seeded(PowerStatus.STRONG);

  /// A cache instance of status stream.
  Stream<PowerStatus> _status$;

  @override
  Stream<PowerStatus> get status$ {
    return _status$ ??= _controller.stream.combineLatest(
      _delegate?.status$ ?? Stream.empty(),
      (debugStatus, status) => isEnabled ? debugStatus : status,
    );
  }

  bool isEnabled = true;

  weak() {
    _controller.add(PowerStatus.WEAK);
  }

  strong() {
    _controller.add(PowerStatus.STRONG);
  }
}
