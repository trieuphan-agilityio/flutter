import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('display ad', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      driver?.close();
    });

    test('wait for ad to display and verify ad info', () async {
      final permissionList = find.byValueKey('permission_list');
      await driver.waitFor(permissionList);

      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.byValueKey('open_debug_dashboard'));

      final debugDashboard = find.byValueKey('debug_dashboard');
      await driver.waitFor(debugDashboard);

      // Gps Debugger is on
      await driver.tap(find.byValueKey('gps_debugger'));

      // Permission is allowed
      await driver.tap(find.byValueKey('permission_debugger'));
      await driver.tap(find.byValueKey('permission_debugger_state_1'));

      // Power is strong
      await driver.tap(find.byValueKey('power_debugger'));

      // close Debug Dashboard
      await driver.tap(find.byTooltip('Close'));

      final adView = find.byValueKey('ad_view');
      await driver.waitFor(adView);
    });
  }, timeout: Timeout(Duration(seconds: 30)));
}
