import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric expectAdIsDisplayingStep() {
  return then<FlutterWorld>(
    'I see an Ad is displaying',
    (context) async {
      final adView = find.byValueKey('ad_view');
      await context.world.driver.waitFor(adView);
    },
  );
}
