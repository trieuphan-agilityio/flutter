import 'dart:async';
import 'dart:math';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/subjects.dart';

abstract class MovementDetector implements Service {
  Stream<MovementState> get state$;
}

/// Time in seconds it must elapse before grabbing location to calculate
/// vehicle's velocity repeatedly.
const int _kLocationRefreshInterval = 5;

/// Lower than or equal this value, the vehicle is considered not moving.
const int _kVelocityThreshold = 3; // 3 m/s

class MovementDetectorImpl with ServiceMixin implements MovementDetector {
  final BehaviorSubject<MovementState> _controller;
  final Stream<LatLng> _latLng$;
  final List<LatLng> _buffer = [];

  MovementDetectorImpl(this._latLng$)
      : _controller =
            BehaviorSubject<MovementState>.seeded(MovementState.notMoving) {
    backgroundTask = ServiceTask(() async {
      final state = await _detectMovement([..._buffer]);
      _buffer.clear();
      _controller.add(state);
    }, _kLocationRefreshInterval);
  }

  @override
  Future<void> start() {
    super.start();
    disposer.autoDispose(_latLng$.listen(_buffer.add));
    return null;
  }

  Stream<MovementState> get state$ => _state$ ??= _controller.stream.distinct();

  Future<MovementState> _detectMovement(Iterable<LatLng> listOfLatLng) async {
    // If there is no location report during last [_kLocationRefreshInterval]
    // seconds, then it is considered not moving.
    if (listOfLatLng.length <= 1) return MovementState.notMoving;

    double distance = 0;
    LatLng a = listOfLatLng.first;

    for (final b in listOfLatLng.skip(1)) {
      distance += await _SimpleDistanceCalculator.distance(a, b);
      a = b;
    }

    final time = _kLocationRefreshInterval;
    final velocity = distance / time.toDouble();

    // keep reference to current velocity for testing purpose
    currentVelocity = velocity;

    if (velocity > 0) {
      Log.debug(
          'MovementDetector measured velocity ~ ${velocity.toInt()} m/s.');
    }

    if (velocity >= _kVelocityThreshold) {
      return MovementState.moving;
    } else {
      return MovementState.notMoving;
    }
  }

  /// A cache instance of [state$], it prevents stream transformation is executed
  /// when the [state$] getter is called.
  Stream<MovementState> _state$;

  @visibleForTesting
  double currentVelocity = 0;
}

class _SimpleDistanceCalculator {
  // calculate distance (in Meter) between two points.
  static Future<double> distance(LatLng a, LatLng b) async {
    // https://stackoverflow.com/a/54138876
    double calculateDistance(lat1, lng1, lat2, lng) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lng - lng1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    return calculateDistance(a.lat, a.lng, b.lat, b.lng) * 1000;
  }
}
