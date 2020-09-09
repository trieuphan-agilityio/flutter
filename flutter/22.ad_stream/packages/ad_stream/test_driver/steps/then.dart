import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric expectAdIsDisplaying() {
  return then1<String, FlutterWorld>(
    RegExp('(I|Passenger) see(s) an ad is displaying'),
    (_, context) async {
      final adView = find.byValueKey('ad_view');
      await FlutterDriverUtils.isPresent(context.world.driver, adView);
    },
  );
}

StepDefinitionGeneric adTargetGender() {
  return then1<String, FlutterWorld>(
    'The displaying ad targets to {string} audience',
    (gender, context) async {
      final adView = find.byValueKey('ad_view');
      await FlutterDriverUtils.isPresent(context.world.driver, adView);
    },
  );
}

StepDefinitionGeneric adTargetAgeRange() {
  return then1<int, FlutterWorld>(
    'The displaying ad targets to age range that includes {int}',
    (age, context) async {
      final adView = find.byValueKey('ad_view');
      await FlutterDriverUtils.isPresent(context.world.driver, adView);
    },
  );
}
