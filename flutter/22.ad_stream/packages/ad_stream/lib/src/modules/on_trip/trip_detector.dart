import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/subjects.dart';

import 'face.dart';
import 'trip_state.dart';

abstract class TripDetector implements Service {
  Stream<TripState> get state$;
}

class TripDetectorImpl with ServiceMixin implements TripDetector {
  final BehaviorSubject<TripState> _controller;
  final Stream<MovementState> movement$;
  final Stream<List<Face>> faces$;

  TripDetectorImpl(this.movement$, this.faces$)
      : _controller = BehaviorSubject<TripState>.seeded(TripState.offTrip());

  Stream<TripState> get state$ => _trip$ ??= _controller.stream.distinct();

  MovementState _movement;
  List<Face> _faces;

  /// There are three values can be returned here:
  ///  - OnTrip
  ///  - OffTrip
  ///  - Undetermined
  _checkState() {
    Log.debug('TripDetector observed'
        '${_movement == null ? "" : " $_movement"}'
        '${_faces == null ? "." : ", $_faces."}');

    if (_movement == null || _faces == null) {
      // not change if the values are undetermined.
      return;
    }

    if (_movement == MovementState.moving && _faces.isNotEmpty) {
      // just blinkly pick first person as a Face Id for the trip
      _controller.add(TripState.onTrip(_faces));
    }

    if (_movement == MovementState.notMoving && _faces.isEmpty) {
      _controller.add(TripState.offTrip());
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

    return null;
  }

  @override
  Future<void> stop() {
    super.stop();

    // Trip is considered as dropped off if service has stopped.
    _controller.add(TripState.offTrip());
    return null;
  }

  /// A cache instance of [state$]. It help to prevent re-computing
  /// stream transformation.
  Stream<TripState> _trip$;

  final Disposer _disposer = Disposer();
}
