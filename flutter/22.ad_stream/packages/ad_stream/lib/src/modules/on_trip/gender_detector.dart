import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/subjects.dart';

abstract class GenderDetector implements Service {
  Stream<PassengerGender> get gender$;

  /// bind its lifecycle to [tripState$] stream.
  listenToTripState(Stream<TripState> tripState$);
}

class GenderDetectorImpl with ServiceMixin implements GenderDetector {
  final StreamController<PassengerGender> _controller;
  final Stream<List<Face>> _faces$;

  GenderDetectorImpl(this._faces$)
      : _controller = BehaviorSubject<PassengerGender>();

  Stream<PassengerGender> get gender$ => _controller.stream;

  Future<PassengerGender> _detectGender(List<Face> faces) async {
    // FIXME
    return PassengerGender.male;
  }

  listenToTripState(Stream<TripState> tripState$) {
    tripState$.listen((tripState) {
      if (tripState == TripState.onTrip) {
        start();
      } else if (tripState == TripState.offTrip) {
        stop();
      }
    });
  }

  @override
  Future<void> start() {
    super.start();

    final subscription = _faces$.listen((faces) async {
      final gender = await _detectGender(faces);
      _controller.add(gender);

      Log.debug('GenderDetector detected $gender.');
    });

    _disposer.autoDispose(subscription);

    Log.info('GenderDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _disposer.cancel();

    Log.info('GenderDetector stopped.');
    return null;
  }

  final Disposer _disposer = Disposer();
}
