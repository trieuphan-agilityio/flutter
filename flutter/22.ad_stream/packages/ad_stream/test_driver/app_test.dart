import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/expect_ad_is_displaying.dart';
import 'steps/i_am_a_visitor.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
    ]
    ..stepDefinitions = [
      iAmAVisitor(),
      expectAdIsDisplayingStep(),
    ]
    ..restartAppBetweenScenarios = false
    ..targetAppPath = "test_driver/app.dart"
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}
