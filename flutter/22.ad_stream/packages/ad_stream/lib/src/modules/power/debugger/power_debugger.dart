import 'dart:async';

import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class PowerDebugger implements Debugger<PowerState> {
  /// Set WEAK status
  weak();

  /// Set STRONG status
  strong();
}

class PowerDebuggerImpl with DebuggerMixin implements PowerDebugger {
  PowerDebuggerImpl()
      : _subject = BehaviorSubject<PowerState>.seeded(PowerState.strong);

  Stream<PowerState> get value$ => _subject.stream;

  weak() {
    toggle(true);
    _subject.add(PowerState.weak);
  }

  strong() {
    toggle(true);
    _subject.add(PowerState.strong);
  }

  final BehaviorSubject<PowerState> _subject;
}
