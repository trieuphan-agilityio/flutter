import 'dart:math';

import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

import 'service.dart';

abstract class MovementDetector implements Service {
  Stream<bool> get isMoving$;
}

/// Time in seconds it must elapse before grabbing location to calculate
/// vehicle's velocity repeatedly.
const int _kLocationRefreshInterval = 4;

/// Lower than or equal this value, the vehicle is considered not moving.
const int _kVelocityThreshold = 3; // 3 m/s

class MovementDetectorImpl with ServiceMixin implements MovementDetector {
  final BehaviorSubject<bool> _controller;
  final Stream<LatLng> _latLng$;
  final List<LatLng> _buffer = [];

  MovementDetectorImpl(this._latLng$)
      : _controller = BehaviorSubject<bool>.seeded(false) {
    backgroundTask = ServiceTask(() async {
      // copy the buffer instance to avoid concurrent modification.
      final isMoving = await _detectMovement([..._buffer]);
      _controller.add(isMoving);
      _buffer.clear();
    }, _kLocationRefreshInterval);
  }

  @override
  start() async {
    super.start();
    disposer.autoDispose(_latLng$.listen(_buffer.add));
  }

  Stream<bool> get isMoving$ => _isMoving$ ??= _controller.stream.distinct();

  Future<bool> _detectMovement(Iterable<LatLng> listOfLatLng) async {
    // If there is no location report during last [_kLocationRefreshInterval]
    // seconds, then it is considered not moving.
    if (listOfLatLng.length <= 1) return false;

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
      return true;
    } else {
      return false;
    }
  }

  /// A cache instance of [_isMoving$], it prevents stream transformation is
  /// executed when the [_isMoving$] getter is called.
  Stream<bool> _isMoving$;

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
