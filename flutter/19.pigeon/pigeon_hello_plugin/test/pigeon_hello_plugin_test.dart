import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pigeon_hello_plugin/pigeon_hello_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('pigeon_hello_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PigeonHelloPlugin.platformVersion, '42');
  });
}
