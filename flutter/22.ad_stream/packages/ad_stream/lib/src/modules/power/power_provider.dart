import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:battery/battery.dart';
import 'package:rxdart/rxdart.dart';

enum PowerState { weak, strong }

abstract class PowerProvider {
  Stream<PowerState> get state$;
}

class PowerProviderImpl implements PowerProvider {
  final StreamController<PowerState> subject;
  final Battery battery;

  PowerProviderImpl(
    this.battery,
  ) : subject = BehaviorSubject.seeded(PowerState.weak) {
    battery.onBatteryStateChanged.listen(_verifyPowerState);
  }

  _verifyPowerState(BatteryState batteryState) async {
    if (batteryState == BatteryState.discharging) {
      subject.add(PowerState.strong);
    } else {
      try {
        int batteryLevel = await battery.batteryLevel;
        if (batteryLevel < 20) {
          Log.info('PowerProviderImpl observed battery level $batteryLevel.');
          subject.add(PowerState.weak);
        }
      } catch (_) {
        subject.add(PowerState.weak);
      }
    }
  }

  Stream<PowerState> get state$ => _state$ ??= subject.stream.distinct();

  /// backing field of [state$]
  Stream<PowerState> _state$;
}
