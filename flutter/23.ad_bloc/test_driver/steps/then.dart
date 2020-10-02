import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric passengerSeeAdsDisplaying() {
  return then2<String, Table, FlutterWorld>(
    '(I|We) see the following ads are displaying:',
    (_, dataTable, context) async {
      final driver = context.world.driver;

      List<_DisplayingAd> ads = [];
      for (var row in dataTable.rows) {
        ads.add(_DisplayingAd(
          row.columns.elementAt(0),
          int.parse(row.columns.elementAt(1)),
          row.columns.elementAt(2) == 'yes',
        ));
      }

      final toleranceSecs = 5; // 5 seconds

      for (final ad in ads) {
        final isPresent = await FlutterDriverUtils.isPresent(
          driver,
          find.byValueKey('ad_view_${ad.id}'),
          timeout: Duration(seconds: ad.durationSecs + toleranceSecs),
        );
        context.expect('${ad.id} $isPresent', '${ad.id} ${true}');
      }
    },
    configuration: StepDefinitionConfiguration()
      ..timeout = Duration(seconds: 60),
  );
}

class _DisplayingAd {
  final String id;
  final int durationSecs;
  final bool canSkip;

  _DisplayingAd(this.id, this.durationSecs, this.canSkip);
}
