import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:battery_swift/battery_swift.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.demo.io/battery');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 42;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getBatteryLevel', () async {
    final battery = BatterySwift();
    expect(await battery.batteryLevel, 42);
  });
}
