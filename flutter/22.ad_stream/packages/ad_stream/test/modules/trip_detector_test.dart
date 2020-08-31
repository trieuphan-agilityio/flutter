import 'dart:async';

import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/on_trip/face.dart';
import 'package:ad_stream/src/modules/on_trip/photo.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common/utils.dart';

main() {
  StreamController<MovementState> movementState$Controller;
  StreamController<List<Face>> faces$Controller;

  TripDetectorImpl tripDetector;

  List<TripState> emittedValues;
  List<String> errors;
  bool isDone;

  group('TripDetectorImpl', () {
    setUp(() {
      movementState$Controller = StreamController<MovementState>();
      faces$Controller = StreamController<List<Face>>();

      tripDetector = TripDetectorImpl(
        movementState$Controller.stream,
        faces$Controller.stream,
      );

      emittedValues = [];
      errors = [];
      isDone = false;

      tripDetector.state$.listen(
        emittedValues.add,
        onError: errors.add,
        onDone: () => isDone = true,
      );
    });

    tearDown(() {
      movementState$Controller.close();
      faces$Controller.close();
    });

    test('can detect the starting of trip', () async {
      await tripDetector.start();
      await flushMicrotasks();
      expect(emittedValues, [TripState.offTrip()]);

      // vehicle is moving, passenger's photo hasn't capture yet
      movementState$Controller.add(MovementState.moving);
      await flushMicrotasks();

      // trip hasn't detected.
      expect(emittedValues, [TripState.offTrip()]);

      // then passengers were detected.
      final passengers = [Face('face1', Photo('path/to/photo1.jpg'))];
      faces$Controller.add(passengers);
      await flushMicrotasks();

      // trip is started
      expect(emittedValues, [
        TripState.offTrip(),
        TripState.onTrip(passengers),
      ]);

      await tripDetector.stop();
      expect(emittedValues, [
        TripState.offTrip(),
        TripState.onTrip(passengers),
        TripState.offTrip(),
      ]);
      expect(errors, []);
      expect(isDone, false);
    });

    test(
        'should not stop the trip while '
        'vehicle stopped and passengers still there.', () async {
      await tripDetector.start();
      await flushMicrotasks();

      movementState$Controller.add(MovementState.moving);

      final passengers = [Face('face1', Photo('path/to/photo1.jpg'))];
      faces$Controller.add(passengers);

      await flushMicrotasks();

      // trip is started
      expect(emittedValues, [
        TripState.offTrip(),
        TripState.onTrip(passengers),
      ]);

      // vehicle stops moving
      movementState$Controller.add(MovementState.notMoving);
      await flushMicrotasks();

      // still on trip
      expect(emittedValues, [
        TripState.offTrip(),
        TripState.onTrip(passengers),
      ]);

      // passengers left.
      faces$Controller.add([]);
      await flushMicrotasks();

      // trip is dropped off
      expect(emittedValues, [
        TripState.offTrip(),
        TripState.onTrip(passengers),
        TripState.offTrip(),
      ]);
      expect(errors, []);
      expect(isDone, false);
    });
  });
}
