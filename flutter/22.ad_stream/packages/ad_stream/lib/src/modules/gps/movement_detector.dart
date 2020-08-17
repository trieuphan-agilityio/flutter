import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:stream_transform/stream_transform.dart';

abstract class MovementDetector {
  Stream<MovementStatus> get status$;
}

/// How long before checking location to calculate vehicle velocity again?
const int _kLocationRefreshInterval = 5; // 5 seconds

/// Lower than or equal this value, the vehicle is considered not moving.
const int _kVelocityThreshold = 3; // 3 m/s

class MovementDetectorImpl implements MovementDetector {
  final StreamController<MovementStatus> _controller;

  MovementDetectorImpl(Stream<LatLng> latLng$)
      : _controller = StreamController<MovementStatus>.broadcast()
          ..add(MovementStatus.notMoving) {
    /// when the refresh trigger emits event, values from latLng$ are collected
    /// and emits on new return stream.
    final refreshTrigger =
        Stream.periodic(Duration(seconds: _kLocationRefreshInterval));
    latLng$.buffer(refreshTrigger).listen(_detectMovement);
  }

  Stream<MovementStatus> get status$ =>
      _status$ ??= _controller.stream.distinct();

  _detectMovement(List<LatLng> listOfLatLng) {
    // there is no movement during last [_kLocationRefreshInterval] seconds
    if (listOfLatLng.length <= 1) return MovementStatus.notMoving;

    int distance = 0;
    LatLng a = listOfLatLng.first;

    listOfLatLng.skip(1).forEach((b) {
      distance += _DistanceCalculator.distance(a, b);
      a = b;
    });

    final velocity =
        _VelocityCalculator.velocity(distance, _kLocationRefreshInterval);

    if (velocity >= _kVelocityThreshold) {
      _controller.add(MovementStatus.moving);
    } else {
      _controller.add(MovementStatus.notMoving);
    }
  }

  /// A cache instance of [status$], it prevents stream transformation is executed
  /// when the [status$] getter is called.
  Stream<MovementStatus> _status$;
}

class _DistanceCalculator {
  // FIXME calculate distance between two points [previous] and [latLng]
  static int distance(LatLng a, LatLng b) {
    return 10;
  }
}

class _VelocityCalculator {
  /// m/s
  static int velocity(int distanceMeter, int timeSecs) {
    return distanceMeter ~/ timeSecs;
  }
}
