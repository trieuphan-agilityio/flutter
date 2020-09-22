import 'dart:async';

import 'package:battery/battery.dart';
import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/src/service/debugger_factory.dart';

import 'service.dart';

abstract class PowerProvider implements Service {
  Stream<bool> get isStrong$;
}

class PowerProviderImpl with ServiceMixin implements PowerProvider {
  PowerProviderImpl({this.debugger})
      : controller = StreamController.broadcast();

  final PowerDebugger debugger;
  final StreamController<bool> controller;
  final Battery battery = Battery();

  Stream<bool> get isStrong$ => _isStrong$ ??= controller.stream.distinct();

  @override
  start() async {
    super.start();

    if (debugger == null) {
      final sub = battery.onBatteryStateChanged.listen(_verifyPower);
      disposer.autoDispose(sub);
    } else {
      controller.add(debugger.isStrong);
    }
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
