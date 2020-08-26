import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

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
  final StreamController<TripState> _controller;
  final Stream<PowerState> power$;
  final Stream<MovementState> movement$;
  final Stream<List<Face>> faces$;

  TripDetectorImpl(this.power$, this.movement$, this.faces$)
      : _controller = StreamController<TripState>.broadcast()
          ..add(TripState.offTrip);

  Stream<TripState> get state$ => _trip$ ??= _controller.stream.distinct();

  @override
  Future<void> start() {
    super.start();

    final subscription = CombineLatestStream.combine3(power$, movement$, faces$,
        (PowerState power, MovementState movement, List<Face> faces) {
      if (power == PowerState.strong &&
          movement == MovementState.moving &&
          faces.isEmpty) return TripState.onTrip;

      if (power == PowerState.weak &&
          movement == MovementState.notMoving &&
          faces.isEmpty) return TripState.offTrip;

      return null;
    }).where((e) => e != null).listen(_controller.add);

    _disposer.autoDispose(subscription);

    Log.info('TripDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();

    // Trip is considered as dropped off if service has stopped.
    _controller.add(TripState.offTrip);

    _disposer.cancel();

    Log.info('TripDetector stopped.');
    return null;
  }

  /// A cache instance of [state$]. It help to prevent re-computing
  /// stream transformation.
  Stream<TripState> _trip$;

  final Disposer _disposer = Disposer();
}
