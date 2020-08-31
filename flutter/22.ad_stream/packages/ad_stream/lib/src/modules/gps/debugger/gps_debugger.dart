import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route_loader.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsDebugger implements Debugger {
  Stream<LatLng> get latLng$;

  /// Invoke this function to load debug routes were defined.
  Future<List<DebugRoute>> loadRoutes();

  /// Invoke this method to replay the records [LatLng] value from sample data.
  /// It would produce [latLng$] events follow the order and time of the recorded.
  ///
  /// Future is completed when route has done.
  Future<void> simulateRoute(DebugRoute route);

  /// Pause the simulating route.
  pauseSimulating();

  /// Resume the paused route.
  resumeSimulating();

  /// Stop simulating route.
  stopSimulating();
}

class GpsDebuggerImpl with DebuggerMixin implements GpsDebugger {
  final BehaviorSubject<LatLng> _controller;

  GpsDebuggerImpl() : _controller = BehaviorSubject<LatLng>() {
    isOn.addListener(() {
      // stop the simulating route when debugger is off.
      if (!isOn.value) stopSimulating();
    });
  }

  Stream<LatLng> get latLng$ => _latLng$ ??= _controller.stream;

  final _routeLoader = DebugRouteLoaderImpl();

  StreamSubscription<LatLng> simulatingSubscription;

  Future<void> simulateRoute(DebugRoute route) {
    // make sure that debugger is enabled.
    toggle(true);

    // stop previous simulating if needs.
    stopSimulating();

    final completer = Completer();

    simulatingSubscription = route.latLng$.listen(
      _controller.add,
      cancelOnError: true,
      onError: (_) {
        completer.completeError('Got error while simulating ${route.id}');
      },
      onDone: () {
        Log.debug('GpsDebuggerImpl has done simulating ${route.id}');
        completer.complete();
      },
    );

    Log.info('GpsDebugger is simulating route ${route.name}.');

    return completer.future;
  }

  pauseSimulating() {
    simulatingSubscription?.pause();
  }

  resumeSimulating() {
    simulatingSubscription?.resume();
  }

  stopSimulating() {
    simulatingSubscription?.cancel();
    simulatingSubscription = null;
  }

  Future<List<DebugRoute>> loadRoutes() async {
    return _routeLoader.load();
  }

  /// Backing field of [latLng$]
  Stream<LatLng> _latLng$;
}
