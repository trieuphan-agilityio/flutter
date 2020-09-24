import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '_utils.dart';

StepDefinitionGeneric driverOnboarded() {
  return given<FlutterWorld>(
    'Driver onboarded',
    (context) async {
      final driver = context.world.driver;
      //await waitForPermissionUI(driver);
      await openDebugDashboard(driver);
      await FlutterDriverUtils.tap(
        driver,
        find.byValueKey('driver_onboarded'),
      );
    },
  );
}

StepDefinitionGeneric driverPicksUpPassenger() {
  return given1<String, FlutterWorld>(
    'Driver picked me up on {string}',
    (dateTime, context) async {
      final driver = context.world.driver;
      await FlutterDriverUtils.tap(
        driver,
        find.byValueKey('pick_up_passenger'),
      );
      await FlutterDriverUtils.tap(
        driver,
        find.byValueKey(dateTime),
      );
    },
  );
}

StepDefinitionGeneric passengerIsTakenPhoto() {
  return given2<String, String, FlutterWorld>(
    '(My|Our) photo is located at {String}',
    (_, photoFilePath, context) async {
      final driver = context.world.driver;
      final debugDashboard = find.byValueKey('debug_dashboard');
      final loadPassengersPhotos = find.byValueKey('load_passengers_photos');

      await driver.scrollUntilVisible(debugDashboard, loadPassengersPhotos);
      await FlutterDriverUtils.waitForFlutter(driver);

      await FlutterDriverUtils.tap(driver, loadPassengersPhotos);
      await FlutterDriverUtils.tap(driver, find.byValueKey(photoFilePath));
    },
  );
}
