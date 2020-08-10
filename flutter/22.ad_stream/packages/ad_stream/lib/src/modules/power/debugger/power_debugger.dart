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
        _controller = BehaviorSubject<PowerStatus>();

  @override
  Stream<PowerStatus> get status$ {
    Stream<PowerStatus> delegateStatus$ =
        _delegate == null ? Stream.empty() : _delegate.status$;

    return delegateStatus$.combineLatest(
      _controller.stream,
      (status, debugStatus) => isEnabled ? debugStatus : status,
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
