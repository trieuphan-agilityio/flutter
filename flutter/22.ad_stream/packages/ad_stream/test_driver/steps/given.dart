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
  return given2<String, int, FlutterWorld>(
    'Driver pick up a {word}, {int} years old passenger',
    (gender, age, context) async {
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
