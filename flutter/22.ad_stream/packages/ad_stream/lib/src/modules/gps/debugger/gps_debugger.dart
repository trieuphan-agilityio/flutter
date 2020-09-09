import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/base/debugger.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route_loader.dart';
import 'package:rxdart/rxdart.dart';

abstract class GpsDebugger implements Debugger<LatLng> {
  Stream<LatLng> get value$;

  /// Invoke this function to load debug routes were defined.
  Future<List<DebugRoute>> loadRoutes();

  /// Invoke this method to replay the records [LatLng] value from sample data.
  /// It would produce [value$] events follow the order and time of the recorded.
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
  final BehaviorSubject<LatLng> _subject;

  GpsDebuggerImpl() : _subject = BehaviorSubject<LatLng>() {
    isOn.addListener(() {
      // stop the simulating route when debugger is off.
      if (!isOn.value) stopSimulating();
    });
  }

  Stream<LatLng> get value$ => _subject;

  final _routeLoader = DebugRouteLoaderImpl();

  StreamSubscription<LatLng> _simulatingSubscription;

  Future<void> simulateRoute(DebugRoute route) {
    // make sure that debugger is enabled.
    toggle(true);

    // stop previous simulating if needs.
    stopSimulating();

    final completer = Completer();

    _simulatingSubscription = route.latLng$.listen(
      _subject.add,
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
    _simulatingSubscription?.pause();
  }

  resumeSimulating() {
    _simulatingSubscription?.resume();
  }

  stopSimulating() {
    _simulatingSubscription?.cancel();
    _simulatingSubscription = null;
  }

  Future<List<DebugRoute>> loadRoutes() async {
    return _routeLoader.load();
  }
}
