import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:stream_transform/stream_transform.dart';

abstract class MovementDetector implements Service {
  Stream<MovementState> get state$;
}

/// How long before checking location to calculate vehicle velocity again?
const int _kLocationRefreshInterval = 5; // 5 seconds

/// Lower than or equal this value, the vehicle is considered not moving.
const int _kVelocityThreshold = 3; // 3 m/s

class MovementDetectorImpl with ServiceMixin implements MovementDetector {
  final StreamController<MovementState> _controller;
  final Stream<LatLng> _latLng$;

  MovementDetectorImpl(this._latLng$)
      : _controller = StreamController<MovementState>.broadcast()
          ..add(MovementState.notMoving);

  start() {
    super.start();

    /// when the refresh trigger emits event, values from latLng$ are collected
    /// and emits on new return stream.
    final refreshTrigger =
        Stream.periodic(Duration(seconds: _kLocationRefreshInterval));

    final disposable = _latLng$.buffer(refreshTrigger).listen(_detectMovement);
    _disposer.autoDispose(disposable);

    Log.info('MovementDetector started.');
    return null;
  }

  stop() {
    super.stop();
    _disposer.cancel();

    Log.info('MovementDetector stopped.');
    return null;
  }

  Stream<MovementState> get state$ => _state$ ??= _controller.stream.distinct();

  _detectMovement(List<LatLng> listOfLatLng) {
    // there is no movement during last [_kLocationRefreshInterval] seconds
    if (listOfLatLng.length <= 1) return MovementState.notMoving;

    int distance = 0;
    LatLng a = listOfLatLng.first;

    listOfLatLng.skip(1).forEach((b) {
      distance += _DistanceCalculator.distance(a, b);
      a = b;
    });

    final velocity =
        _VelocityCalculator.velocity(distance, _kLocationRefreshInterval);

    if (velocity >= _kVelocityThreshold) {
      _controller.add(MovementState.moving);
    } else {
      _controller.add(MovementState.notMoving);
    }
  }

  /// A cache instance of [state$], it prevents stream transformation is executed
  /// when the [state$] getter is called.
  Stream<MovementState> _state$;

  final _disposer = Disposer();
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
