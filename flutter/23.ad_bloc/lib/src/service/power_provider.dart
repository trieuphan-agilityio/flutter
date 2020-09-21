import 'dart:async';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/src/service/debugger.dart';
import 'package:battery/battery.dart';
import 'package:rxdart/rxdart.dart';

abstract class PowerProvider {
  Stream<bool> get isStrong$;

  start();
  stop();
}

class PowerProviderImpl implements PowerProvider {
  PowerProviderImpl({this.debugger}) : subject = BehaviorSubject.seeded(false);

  final PowerDebugger debugger;
  final BehaviorSubject<bool> subject;
  final Battery battery = Battery();
  final Disposer disposer = Disposer();

  Stream<bool> get isStrong$ => _isStrong$ ??= subject.stream.distinct();

  start() {
    final sub = battery.onBatteryStateChanged.listen(_verifyPower);
    disposer.autoDispose(sub);
  }

  stop() {
    disposer.cancel();
  }

  _verifyPower(BatteryState batteryState) {
    if (debugger == null)
      _doVerifyPower(batteryState);
    else
      _verifyPowerWithDebugger();
  }

  _verifyPowerWithDebugger() {
    subject.add(debugger.isStrong);
  }

  _doVerifyPower(BatteryState batteryState) async {
    if (batteryState == BatteryState.charging) {
      subject.add(true);
    } else {
      try {
        int batteryLevel = await battery.batteryLevel;
        if (batteryLevel < 20) {
          Log.info('PowerProviderImpl observed battery level $batteryLevel.');
          subject.add(false);
        } else {
          subject.add(true);
        }
      } catch (_) {
        subject.add(false);
      }
    }
  }

  /// backing field of [isStrong$]
  Stream<bool> _isStrong$;
}
