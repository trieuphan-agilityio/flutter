import 'package:ad_stream/src/modules/gps/mock/fixed_gps_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

import '../common/base.dart';

main() {
  group('GpsControllerImpl', () async {
    final config = await configFuture;
    final gpsController = FixedGpsController(config);

    test('can start', () async {
      fakeAsync((async) {
        gpsController.start();
        async.elapse(Duration(seconds: 3));
      });
    });
  });
}
