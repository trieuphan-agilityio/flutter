import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric expectAdIsDisplaying() {
  return then2<String, String, FlutterWorld>(
    RegExp('(I|Passenger) (see|expect)(s) an ad is displaying'),
    (_, __, context) async {
      final adView = find.byValueKey('ad_view');
      await FlutterDriverUtils.isPresent(context.world.driver, adView);
    },
  );
}

StepDefinitionGeneric expectScreensaverIsDisplaying() {
  return then2<String, String, FlutterWorld>(
    RegExp('(I|Passenger) (see|expect)(s) a screensaver is displaying'),
    (_, __, context) async {
      final screensaver = find.byValueKey('ad_placeholder');
      await FlutterDriverUtils.isPresent(context.world.driver, screensaver);
    },
  );
}

StepDefinitionGeneric adTargetGender() {
  return then1<String, FlutterWorld>(
    'The displaying ad targets to {string} audience',
    (gender, context) async {
      // TODO assert gender
      final adView = find.byValueKey('ad_view');
      await FlutterDriverUtils.isPresent(context.world.driver, adView);
    },
  );
}

StepDefinitionGeneric adTargetAgeRange() {
  return then1<int, FlutterWorld>(
    'The displaying ad targets to age range that includes {int}',
    (age, context) async {
      // TODO assert age range
      final adView = find.byValueKey('ad_view');
      await FlutterDriverUtils.isPresent(context.world.driver, adView);
    },
  );
}
