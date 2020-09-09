import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '_utils.dart';

_openDebugDashboard(FlutterDriver driver, Future Function() then) async {
  await waitForPermissionUI(driver);
  await openDebugDashboard(driver);
  await then();
  await closeDebugDashboard(driver);
  await notSeePermissionUI(driver);
}

StepDefinitionGeneric iAmAVisitor() {
  return given<FlutterWorld>(
    'I am a visitor',
    (context) async {
      final driver = context.world.driver;
      await _openDebugDashboard(driver, () async {
        await FlutterDriverUtils.tap(
          driver,
          find.byValueKey('story_visitor'),
        );
      });
    },
  );
}

StepDefinitionGeneric passengerIsAboutToFinishATrip() {
  return given<FlutterWorld>(
    'Passenger is about to finish a trip',
    (context) async {
      final driver = context.world.driver;
      await _openDebugDashboard(driver, () async {
        await FlutterDriverUtils.tap(
          driver,
          find.byValueKey('story_about_finish_trip'),
        );
      });
    },
  );
}

StepDefinitionGeneric driverPickUpAPassenger() {
  return given1<String, FlutterWorld>(
    'Driver pick up a {word} passenger',
    (gender, context) async {
      final driver = context.world.driver;
      await _openDebugDashboard(driver, () async {
        await FlutterDriverUtils.tap(
          driver,
          find.byValueKey('story_pick_up_passenger'),
        );
      });
    },
  );
}

StepDefinitionGeneric iAmSeeingVideoAd() {
  return given<FlutterWorld>(
    'I am seeing an video ad is playing',
    (context) async {
      final driver = context.world.driver;
      await _openDebugDashboard(driver, () async {
        await FlutterDriverUtils.tap(driver, find.byValueKey('story_video_ad'));
      });
    },
  );
}

StepDefinitionGeneric passengerAge() {
  return given1<int, FlutterWorld>(
    'Passenger is {int} years old',
    (age, context) async {
      final driver = context.world.driver;
      await openDebugDashboard(driver);
      await closeDebugDashboard(driver);
    },
  );
}
