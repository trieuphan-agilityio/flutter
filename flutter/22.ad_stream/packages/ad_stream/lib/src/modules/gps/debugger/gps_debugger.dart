import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route_loader.dart';

abstract class GpsDebugger implements Debugger {
  Stream<LatLng> get latLng$;

  List<DebugRoute> get routesToSimulate;

  /// Invoke this function to load debug routes were defined.
  Future loadRoutes();

  /// Invoke this method to replay the records [LatLng] value from sample data.
  /// It would produce [latLng$] events follow the order and time of the recorded.
  simulate(DebugRoute route);

  /// Pause the simulating route.
  pause();

  /// Resume the paused route.
  resume();

  /// Stop simulating route.
  stop();
}

class GpsDebuggerImpl with DebuggerMixin implements GpsDebugger {
  final StreamController<LatLng> _controller;

  GpsDebuggerImpl() : _controller = StreamController<LatLng>() {
    isOn.addListener(() {
      // stop the simulating route when debugger is off.
      if (!isOn.value) stop();
    });
  }

  Stream<LatLng> get latLng$ => _controller.stream;

  final _routeLoader = DebugRouteLoaderImpl();

  List<DebugRoute> get routesToSimulate => _routesToSimulate ?? [];

  StreamSubscription<LatLng> simulatingSubscription;

  simulate(DebugRoute route) {
    // make sure that debugger is enabled.
    toggle(true);

    // stop previous simulating if needs.
    stop();

    simulatingSubscription = route.latLng$.listen(
      _controller.add,
      cancelOnError: true,
      onDone: () {
        Log.debug('GpsDebuggerImpl has done simulating ${route.id}');
      },
    );
  }

  pause() {
    simulatingSubscription?.pause();
  }

  resume() {
    simulatingSubscription?.resume();
  }

  stop() {
    simulatingSubscription?.cancel();
    simulatingSubscription = null;
  }

  Future loadRoutes() async {
    _routesToSimulate = await _routeLoader.load();
    return null;
  }

  /// Backing field of [routesToSimulate]
  List<DebugRoute> _routesToSimulate;
}
