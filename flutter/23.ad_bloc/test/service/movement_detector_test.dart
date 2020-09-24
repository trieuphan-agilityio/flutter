import 'package:ad_bloc/src/service/gps/debug_route_loader.dart';
import 'package:ad_bloc/src/service/movement_detector.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

main() {
  MovementDetectorImpl movementDetector;
  List<bool> emittedValues;
  List<String> errors;
  bool isDone;

  group('MovementDetectorImpl', () {
    setUp(() async {
      emittedValues = [];
      errors = [];
      isDone = false;
    });

    test(
        'can detect movement when simulating '
        'the sample route 10XuanThuy_218XuanThuy', () async {
      final routes = await DebugRouteLoader.singleton().load();
      // the route is 10XuanThuy_218XuanThuy in sample_data.dart
      final testRoute = routes[2];
      // how long does it take to finish simulating the sample route.
      final durationToFinishSampleRoute = Duration(milliseconds: 84373);

      movementDetector = MovementDetectorImpl(testRoute.latLng$);

      movementDetector.isMoving$.listen(
        emittedValues.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );

      fakeAsync((async) {
        movementDetector.start();
        async.elapse(durationToFinishSampleRoute);

        // after finishing the route, it takes another 5 seconds to figure out
        // that the vehicle is not moving.
        async.elapse(Duration(seconds: 5));

        expect(movementDetector.isStarted, true);
        expect(emittedValues, [false, true, false]);
        expect(errors, []);
        expect(isDone, false);
      });
    });
  });
}
