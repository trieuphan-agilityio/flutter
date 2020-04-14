import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// BatteryInfo holds the battery information of the device
class BatteryInfo {
  final int batteryLevel;
  BatteryInfo(this.batteryLevel);
}

/// Emulate the battery API
class MockBattery {
  var _currentValue;
  var _random = Random();

  Future<int> get batteryLevel async {
    var _batteryLevel = _random.nextInt(_currentValue ?? 100);
    _currentValue = _batteryLevel;
    return Future.value(_batteryLevel);
  }
}

/// DeviceInfoService takes data from Battery service via async API
/// and emit value to its stream.
class DeviceInfoService {
  bool _broadcastBattery = false;
  var _battery = MockBattery();

  var _batteryLevelController = StreamController<BatteryInfo>();
  Stream<BatteryInfo> get batteryLevel => _batteryLevelController.stream;

  /// Emit the battery level every 2 seconds
  Future _broadcastBatteryLevel() async {
    _broadcastBattery = true;
    while (_broadcastBattery) {
      int batteryLevel;
      try {
        batteryLevel = await _battery.batteryLevel;
      } catch (e) {
        _batteryLevelController.addError(e);
        stopBroadcast();
      }
      if (batteryLevel != null) {
        _batteryLevelController.add(BatteryInfo(batteryLevel));
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  void stopBroadcast() {
    _broadcastBattery = false;
  }
}

class BatteryScreen extends StatefulWidget {
  @override
  _BatteryScreenState createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final service = DeviceInfoService();
  var isBatteryUnavailable = false;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: BatteryInfo(-1),
      value: service.batteryLevel,
      catchError: (context, error) {
        isBatteryUnavailable = true;
      },
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('The battery level will be updated every 2 seconds.'),
            Consumer<BatteryInfo>(builder: (context, info, _) {
              return Text(
                  'Battery Level: ${isBatteryUnavailable ? 'UNAVAILABLE' : info?.batteryLevel}');
            }),
            Text('Press the "Start" button to start the stream.'),
            RaisedButton(
              onPressed: () {
                isBatteryUnavailable = false;
                service._broadcastBatteryLevel();
              },
              child: Text('Start'),
            )
          ],
        ),
      )),
    );
  }
}
