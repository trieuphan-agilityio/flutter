import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:test/test.dart';

import '../common/base.dart';

main() {
  group('GpsControllerImpl', () {
    final gpsController = FixedGpsController(config);

    test('can start', () async {
      gpsController.latLng$.listen(print);
      gpsController.start();
      await Future.delayed(Duration(seconds: 3));
    });
  });
}
