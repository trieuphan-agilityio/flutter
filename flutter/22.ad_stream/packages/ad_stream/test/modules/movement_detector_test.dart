import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/gps/movement_detector.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';

main() {
  // call native api to calculate distance.
  TestWidgetsFlutterBinding.ensureInitialized();

  GpsDebugger gpsDebugger;
  MovementDetectorImpl movementDetector;
  List<MovementState> emittedValues;
  List<String> errors;
  bool isDone;

  group('MovementDetectorImpl', () {
    setUp(() async {
      emittedValues = [];
      errors = [];
      isDone = false;

      gpsDebugger = GpsDebuggerImpl();
      movementDetector = MovementDetectorImpl(gpsDebugger.latLng$);

      movementDetector.state$.listen(
        emittedValues.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );
    });

    test(
        'can detect movement when simulating '
        'the sample route 10XuanThuy_218XuanThuy', () async {
      final routes = await gpsDebugger.loadRoutes();
      // the route is 10XuanThuy_218XuanThuy in sample_data.dart
      final testRoute = routes[2];
      // how long does it take to finish simulating the sample route.
      final durationToFinishSampleRoute = Duration(milliseconds: 84373);

      fakeAsync((async) {
        movementDetector.start();
        async.elapse(aSecond);
        expect(movementDetector.isStarted, true);

        gpsDebugger.simulateRoute(testRoute);
        async.elapse(durationToFinishSampleRoute);

        expect(emittedValues, [
          MovementState.notMoving,
          MovementState.moving,
          MovementState.notMoving,
        ]);
        expect(errors, []);
        expect(isDone, false);
      });
    });
  });
}
