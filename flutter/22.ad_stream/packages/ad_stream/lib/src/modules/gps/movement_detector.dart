import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';

abstract class MovementDetector implements Service {
  Stream<MovementState> get state$;
}

/// How long before checking location to calculate vehicle velocity again?
const int _kLocationRefreshInterval = 5; // 5 seconds

/// Lower than or equal this value, the vehicle is considered not moving.
const int _kVelocityThreshold = 3; // 1 m/s

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
      distance += await _DistanceCalculator.distance(a, b);
      a = b;
    }

    final time = _kLocationRefreshInterval;
    final velocity = _VelocityCalculator.velocity(distance, time);

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
}

class _DistanceCalculator {
  static final _geoLocator = Geolocator();

  // calculate distance between two points.
  static Future<double> distance(LatLng a, LatLng b) {
    return _geoLocator.distanceBetween(a.lat, a.lng, b.lat, b.lng);
  }
}

class _VelocityCalculator {
  /// m/s
  static double velocity(double distanceMeter, int timeSecs) {
    return distanceMeter / timeSecs.toDouble();
  }
}
