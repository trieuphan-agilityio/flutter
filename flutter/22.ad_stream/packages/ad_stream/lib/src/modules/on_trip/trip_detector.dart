import 'dart:async';

import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:rxdart/rxdart.dart';

enum TripStatus {
  /// Device is considered on trip when Power is [PowerStatus.strong],
  /// face is found and there is movement.
  onTrip,

  /// [TripStatus] is initial set to [TripStatus.offTrip], in order to change from
  /// [onTrip] Power must be [PowerStatus.weak], face not found, no movement.
  offTrip,
}

abstract class TripDetector {
  Stream<TripStatus> get status$;
}

class TripDetectorImpl implements TripDetector {
  final StreamController<TripStatus> _controller;
  final Stream<PowerStatus> powerStatus$;
  final Stream<MovementStatus> movementStatus$;
  final Stream<List<Face>> faces$;

  TripDetectorImpl(this.powerStatus$, this.movementStatus$, this.faces$)
      : _controller = StreamController<TripStatus>.broadcast()
          ..add(TripStatus.offTrip) {
    _detectTrip();
  }

  Stream<TripStatus> get status$ => _status$ ??= _controller.stream.distinct();

  _detectTrip() {
    CombineLatestStream.combine3(
      powerStatus$,
      movementStatus$,
      faces$,
      (PowerStatus power, MovementStatus movement, List<Face> faces) {
        if (power == PowerStatus.strong &&
            movement == MovementStatus.moving &&
            faces.isEmpty) return TripStatus.onTrip;

        if (power == PowerStatus.weak &&
            movement != MovementStatus.notMoving &&
            faces.isEmpty) return TripStatus.offTrip;

        return null;
      },
    ).where((e) => e != null).listen(_controller.add);
  }

  /// A cache instance of [status$]. It help to prevent re-computing
  /// stream transformation.
  Stream<TripStatus> _status$;
}
