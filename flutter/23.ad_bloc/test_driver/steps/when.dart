import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '_utils.dart';

StepDefinitionGeneric driverDrives() {
  return when2<String, String, FlutterWorld>(
    RegExp(r'Driver drives (us|me) {string}'),
    (_, routeName, context) async {
      final driver = context.world.driver;
      final debugDashboard = find.byValueKey('debug_dashboard');
      final loadRoutes = find.byValueKey('load_routes');

      await driver.scrollUntilVisible(debugDashboard, loadRoutes);
      await FlutterDriverUtils.waitForFlutter(driver);

      await FlutterDriverUtils.tap(driver, loadRoutes);
      await FlutterDriverUtils.tap(driver, find.byValueKey(routeName));

      await reloadApp(driver);
      await notSeePermissionUI(driver);
    },
  );
}
