import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import 'steps/given.dart';
import 'steps/then.dart';
import 'steps/when.dart';

Future<void> main() {
  final config = FlutterTestConfiguration.DEFAULT([
    /// given
    driverOnboarded(),
    driverPicksUpPassenger(),
    passengerIsTakenPhoto(),

    /// when
    driverDrives(),

    /// then
    passengerSeeAdsDisplaying(),
  ]);
  return GherkinRunner().execute(config);
}
