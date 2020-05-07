import 'dart:async';
import 'dart:async';

import 'package:flutter/services.dart';

class BatterySwift {
  factory BatterySwift() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('plugins.demo.io/battery');
      final EventChannel eventChannel =
          const EventChannel('plugins.demo.io/charging');
      _instance = BatterySwift._(methodChannel, eventChannel);
    }
    return _instance;
  }

  static BatterySwift _instance;

  BatterySwift._(this._methodChannel, this._eventChannel);

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  Stream<String> _onBatteryStateChanged;

  Future<int> get batteryLevel async =>
      await _methodChannel.invokeMethod('getBatteryLevel');

  Stream<String> get onBatteryStateChanged {
    if (_onBatteryStateChanged == null) {
      _onBatteryStateChanged =
          _eventChannel.receiveBroadcastStream().map((event) => '$event');
    }
    return _onBatteryStateChanged;
  }
}
