import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';

enableGpsDebugger(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('gps_debugger'));
}

enablePermissionDebugger(FlutterDriver driver, String permissionState) async {
  await driver.tap(find.byValueKey('permission_debugger'));

  int debugState;
  switch (permissionState) {
    case 'off':
      debugState = 0;
      break;
    case 'always allowed':
      debugState = 1;
      break;
    case 'always denied':
      debugState = 2;
      break;
    default:
      throw ArgumentError('"$permissionState" is not supported');
  }

  await driver.tap(
    find.byValueKey('permission_debugger_state_$debugState'),
  );
}

enablePowerDebugger(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('power_debugger'));
}

openDebugDashboard(FlutterDriver driver) async {
  // do long press on debug button
  final debugButton = find.byValueKey('debug_button');
  await driver.scroll(debugButton, 0, 0, Duration(milliseconds: 400));
  await driver.waitFor(find.byValueKey('debug_dashboard'));
}

closeDebugDashboard(FlutterDriver driver) async {
  await driver.waitFor(find.byValueKey('debug_dashboard'));
  await driver.tap(find.byTooltip('Close'));
}

waitForPermissionUI(FlutterDriver driver) async {
  final permissionUI = find.byValueKey('permission_list');
  await FlutterDriverUtils.isPresent(driver, permissionUI);
}

notSeePermissionUI(FlutterDriver driver) async {
  final permissionUI = find.byValueKey('permission_list');
  await FlutterDriverUtils.isAbsent(driver, permissionUI);
}
