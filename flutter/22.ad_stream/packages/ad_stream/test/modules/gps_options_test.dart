import 'dart:async';

import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common/utils.dart';

main() {
  group('GpsOptions', () {
    StreamController<GpsOptions> controller;
    Stream<GpsOptions> stream;
    List<GpsOptions> emittedValues = [];

    setUp(() {
      controller = StreamController<GpsOptions>();
      stream = controller.stream.distinct();
      emittedValues = [];

      stream.listen(emittedValues.add);
    });

    tearDown(() {
      controller.close();
    });

    test('should be distincted', () async {
      controller.add(GpsOptions(accuracy: GpsAccuracy.high, distanceFilter: 1));
      await flushMicrotasks();

      expect(
        emittedValues,
        [GpsOptions(accuracy: GpsAccuracy.high, distanceFilter: 1)],
      );

      controller.add(GpsOptions(accuracy: GpsAccuracy.best, distanceFilter: 2));
      controller.add(GpsOptions(accuracy: GpsAccuracy.best, distanceFilter: 2));
      await flushMicrotasks();

      expect(
        emittedValues,
        [
          GpsOptions(accuracy: GpsAccuracy.high, distanceFilter: 1),
          GpsOptions(accuracy: GpsAccuracy.best, distanceFilter: 2)
        ],
      );
    });
  });
}
