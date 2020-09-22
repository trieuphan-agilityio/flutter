import 'dart:async';

import 'package:ad_bloc/model.dart';
import 'package:ad_bloc/src/service/debugger_factory.dart';
import 'package:ad_bloc/src/service/gps/gps_controller.dart';
import 'package:test/test.dart';

import '../utils.dart';

main() {
  GpsControllerImpl gpsController;
  List<LatLng> emittedValues;
  List<String> errors;
  bool isDone;

  StreamController<LatLng> controllerForAdapter;
  MockGpsAdapter gpsAdapter;

  StreamController<LatLng> controllerForDebugger;
  GpsDebugger gpsDebugger;

  /// emit value to GpsAdapter
  gpsAdapterEmit(LatLng latLng) {
    controllerForAdapter.add(latLng);
  }

  /// emit value to GpsDebugger
  gpsDebuggerEmit(LatLng latLng) {
    controllerForDebugger.add(latLng);
  }

  changeGpsOptions(GpsOptions options) {
    gpsController.changeGpsOptions(options);
  }

  setUpWithoutDebugger() {
    gpsController = GpsControllerImpl(gpsAdapter);
    gpsController.latLng$.listen(
      emittedValues.add,
      onError: errors.add,
      onDone: () => isDone = true,
    );
  }

  setUpWithDebugger() {
    gpsController = GpsControllerImpl(gpsAdapter, debugger: gpsDebugger);
    gpsController.latLng$.listen(
      emittedValues.add,
      onError: errors.add,
      onDone: () => isDone = true,
    );
  }

  group('GpsControllerImpl', () {
    setUp(() {
      emittedValues = [];
      errors = [];
      isDone = false;

      controllerForAdapter = StreamController<LatLng>.broadcast();
      gpsAdapter = MockGpsAdapter(controllerForAdapter.stream);

      controllerForDebugger = StreamController<LatLng>.broadcast();
      gpsDebugger = GpsDebugger(controllerForDebugger.stream);
    });

    tearDown(() {
      controllerForAdapter.close();
      controllerForDebugger.close();
    });

    test('can start stream with GpsOptions', () async {
      setUpWithoutDebugger();

      await gpsController.start();
      await flushMicrotasks();

      changeGpsOptions(GpsOptions(accuracy: GpsAccuracy.high));
      await flushMicrotasks();

      gpsAdapterEmit(LatLng(53.817198, -2.417717));
      await flushMicrotasks();

      expect(gpsAdapter.calledArgs, [GpsOptions(accuracy: GpsAccuracy.high)]);
      expect(emittedValues, [LatLng(53.817198, -2.417717)]);
      expect(errors, []);
      expect(isDone, false);
    });

    test('build new stream when GpsOptions is changed', () async {
      setUpWithoutDebugger();

      await gpsController.start();

      changeGpsOptions(GpsOptions(accuracy: GpsAccuracy.high));
      await flushMicrotasks();

      expect(gpsAdapter.calledArgs, [GpsOptions(accuracy: GpsAccuracy.high)]);

      gpsAdapterEmit(LatLng(53.817198, -2.417717));
      await flushMicrotasks();

      expect(emittedValues, [LatLng(53.817198, -2.417717)]);
      expect(errors, []);
      expect(isDone, false);

      changeGpsOptions(GpsOptions(accuracy: GpsAccuracy.medium));
      await flushMicrotasks();

      gpsAdapterEmit(LatLng(53.817135, -2.418114));
      await flushMicrotasks();

      expect(gpsAdapter.calledArgs, [
        GpsOptions(accuracy: GpsAccuracy.high),
        GpsOptions(accuracy: GpsAccuracy.medium),
      ]);
      expect(emittedValues, [
        LatLng(53.817198, -2.417717),
        LatLng(53.817135, -2.418114),
      ]);
      expect(errors, []);
      expect(isDone, false);
    });

    test('can use stream from debugger when enabled', () async {
      setUpWithDebugger();

      await gpsController.start();
      await flushMicrotasks();

      gpsDebuggerEmit(LatLng(53.817198, -2.417717));
      await flushMicrotasks();

      expect(gpsAdapter.calledArgs, []);
      expect(emittedValues, [LatLng(53.817198, -2.417717)]);
      expect(errors, []);
      expect(isDone, false);
    });
  });
}
