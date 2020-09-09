import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '_utils.dart';

StepDefinitionGeneric driverIsDriving() {
  return when1<String, FlutterWorld>(
    RegExp(r'Driver is driving {string}'),
    (routeName, context) async {
      final driver = context.world.driver;
      await openDebugDashboard(driver);

      final debugDashboard = find.byValueKey('debug_dashboard');
      final simulateRoute = find.byValueKey('simulate_route');

      await driver.scrollUntilVisible(debugDashboard, simulateRoute);
      await FlutterDriverUtils.waitForFlutter(driver);

      await FlutterDriverUtils.tap(driver, simulateRoute);
      await FlutterDriverUtils.tap(driver, find.byValueKey(routeName));

      await closeDebugDashboard(driver);
    },
  );
}
