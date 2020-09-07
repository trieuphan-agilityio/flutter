import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import 'utils.dart';

StepDefinitionGeneric iAmPassengerStep() {
  return given<FlutterWorld>('I am passenger', (context) async {
    final driver = context.world.driver;
    await waitForPermissionUI(driver);
    await openDebugDashboard(driver);
    await enableGpsDebugger(driver);
    await enablePermissionDebugger(driver, 'always allowed');
    await enablePowerDebugger(driver);
    await closeDebugDashboard(driver);
    await notSeePermissionUI(driver);
  });
}
