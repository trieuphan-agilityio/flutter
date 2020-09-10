import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import 'steps/given.dart';
import 'steps/then.dart';
import 'steps/when.dart';

Future<void> main() {
  final config = FlutterTestConfiguration.DEFAULT([
    /// given
    iAmAVisitor(),
    passengerIsAboutToFinishATrip(),
    driverPickUpAPassenger(),
    iAmSeeingVideoAd(),

    /// when
    driverIsDriving(),

    /// then
    expectAdIsDisplaying(),
    adTargetGender(),
    adTargetAgeRange(),
  ]);
  return GherkinRunner().execute(config);
}
