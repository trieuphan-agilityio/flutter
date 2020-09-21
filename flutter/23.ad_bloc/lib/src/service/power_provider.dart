import 'dart:async';

import 'package:battery/battery.dart';
import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/src/service/debugger_factory.dart';

abstract class PowerProvider {
  Stream<bool> get isStrong$;

  start();
  stop();
}

class PowerProviderImpl implements PowerProvider {
  PowerProviderImpl({this.debugger})
      : controller = StreamController.broadcast();

  final PowerDebugger debugger;
  final StreamController<bool> controller;
  final Battery battery = Battery();
  final Disposer disposer = Disposer();

  Stream<bool> get isStrong$ => _isStrong$ ??= controller.stream.distinct();

  start() {
    if (debugger == null) {
      final sub = battery.onBatteryStateChanged.listen(_verifyPower);
      disposer.autoDispose(sub);
    } else {
      controller.add(debugger.isStrong);
    }
  }

  stop() {
    disposer.cancel();
  }

  _verifyPower(BatteryState batteryState) async {
    if (batteryState == BatteryState.charging) {
      controller.add(true);
    } else {
      try {
        int batteryLevel = await battery.batteryLevel;
        if (batteryLevel < 20) {
          Log.info('PowerProviderImpl observed battery level $batteryLevel.');
          controller.add(false);
        } else {
          controller.add(true);
        }
      } catch (_) {
        controller.add(false);
      }
    }
  }

  /// backing field of [isStrong$]
  Stream<bool> _isStrong$;
}
