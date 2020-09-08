import 'dart:async';
import 'dart:developer';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:battery/battery.dart';
import 'package:rxdart/rxdart.dart';

import 'debugger/power_debugger.dart';

enum PowerState { weak, strong }

abstract class PowerProvider {
  Stream<PowerState> get state$;
}

class PowerProviderImpl with ServiceMixin implements PowerProvider, Service {
  final StreamController<PowerState> _subject;
  final Battery _battery;
  final PowerDebugger _debugger;

  PowerProviderImpl(this._battery, this._debugger)
      : _subject = BehaviorSubject.seeded(PowerState.weak) {
    _battery.onBatteryStateChanged.listen(_verifyPowerState);
    acceptDebugger(_debugger, originalValue$: state$);
  }

  _verifyPowerState(BatteryState batteryState) async {
    if (batteryState == BatteryState.discharging) {
      _subject.add(PowerState.strong);
    } else {
      try {
        int batteryLevel = await _battery.batteryLevel;
        if (batteryLevel < 20) {
          Log.info('PowerProviderImpl observed battery level $batteryLevel.');
          _subject.add(PowerState.weak);
        }
      } catch (_) {
        _subject.add(PowerState.weak);
      }
    }
  }

  Stream<PowerState> get state$ => _state$ ??= _subject.stream.distinct();

  /// backing field of [state$]
  Stream<PowerState> _state$;
}
