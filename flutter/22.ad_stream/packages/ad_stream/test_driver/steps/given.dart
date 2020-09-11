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

StepDefinitionGeneric driverOnboarded() {
  return given<FlutterWorld>(
    'Driver onboarded',
    (context) async {
      final driver = context.world.driver;
      await _openDebugDashboard(driver, () async {
        await FlutterDriverUtils.tap(
          driver,
          find.byValueKey('driver_onboarded'),
        );
      });
    },
  );
}

StepDefinitionGeneric driveOnDate() {
  return given<FlutterWorld>(
    'Driver drives on Sep 12, 2020 at 11:16 am',
    (context) async {
      final driver = context.world.driver;
      await openDebugDashboard(driver);
      await FlutterDriverUtils.tap(
        driver,
        find.byValueKey('drive_on_datetime'),
      );
      await closeDebugDashboard(driver);
    },
  );
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
  return given2<int, String, FlutterWorld>(
    'I am {int} years old, a {string} passenger',
    (age, gender, context) async {
      final driver = context.world.driver;
      await _openDebugDashboard(driver, () async {
        await FlutterDriverUtils.tap(
          driver,
          find.byValueKey('26_female_passenger'),
        );
      });
    },
  );
}

StepDefinitionGeneric groupOfPassenger() {
  return given1<String, FlutterWorld>(
    'Given We are group of passengers, our photo is located at {string}',
    (photoFilePath, context) async {
      final driver = context.world.driver;
      // TODO camera captured photoFilePath
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
