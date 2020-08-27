import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/subjects.dart';

enum TripState {
  /// Device is considered on trip when Power is [PowerState.strong],
  /// face is found and there is movement.
  onTrip,

  /// [TripState] is initial set to [TripState.offTrip], in order to change from
  /// [onTrip] Power must be [PowerState.weak], face not found, no movement.
  offTrip,
}

abstract class TripDetector implements Service {
  Stream<TripState> get state$;
}

class TripDetectorImpl with ServiceMixin implements TripDetector {
  final BehaviorSubject<TripState> _controller;
  final Stream<MovementState> movement$;
  final Stream<List<Face>> faces$;

  TripDetectorImpl(this.movement$, this.faces$)
      : _controller = BehaviorSubject<TripState>.seeded(TripState.offTrip);

  Stream<TripState> get state$ => _trip$ ??= _controller.stream.distinct();

  MovementState _movement;
  List<Face> _faces;

  /// There are three values can be returned here:
  ///  - OnTrip
  ///  - OffTrip
  ///  - Undetermined
  _checkState() {
    Log.debug('TripDetector observed $_movement, $_faces.');

    if (_movement == null || _faces == null) return;

    if (_movement == MovementState.moving && _faces.isNotEmpty) {
      _controller.add(TripState.onTrip);
    }

    if (_movement == MovementState.notMoving && _faces.isEmpty) {
      _controller.add(TripState.offTrip);
    }
  }

  @override
  Future<void> start() {
    super.start();

    _disposer.autoDispose(movement$.listen((newValue) {
      _movement = newValue;
      _checkState();
    }));

    _disposer.autoDispose(faces$.listen((newValue) {
      _faces = newValue;
      _checkState();
    }));

    Log.info('TripDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();

    // Trip is considered as dropped off if service has stopped.
    _controller.add(TripState.offTrip);

    Log.info('TripDetector stopped.');
    return null;
  }

  /// A cache instance of [state$]. It help to prevent re-computing
  /// stream transformation.
  Stream<TripState> _trip$;

  final Disposer _disposer = Disposer();
}
