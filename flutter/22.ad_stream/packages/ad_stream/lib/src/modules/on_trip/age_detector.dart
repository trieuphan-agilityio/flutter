import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/subjects.dart';

abstract class AgeDetector implements Service {
  Stream<PassengerAgeRange> get ageRange$;

  /// bind its lifecycle to [tripState$] stream.
  listenToTripState(Stream<TripState> tripState$);
}

class AgeDetectorImpl with ServiceMixin implements AgeDetector {
  final StreamController<PassengerAgeRange> _controller;
  final Stream<List<Face>> _faces$;

  AgeDetectorImpl(this._faces$)
      : _controller = BehaviorSubject<PassengerAgeRange>();

  Stream<PassengerAgeRange> get ageRange$ => _controller.stream;

  Future<PassengerAgeRange> _detectAgeRange(List<Face> faces) async {
    // FIXME
    return PassengerAgeRange(18, 40);
  }

  @override
  listenToTripState(Stream<TripState> tripState$) {
    Log.debug('AgeDetector listened to Trip\'s state.');

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
      final ageRange = await _detectAgeRange(faces);
      _controller.add(ageRange);

      Log.debug('AgeDetector detected $ageRange.');
    });

    _disposer.autoDispose(subscription);

    Log.info('AgeDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _disposer.cancel();

    Log.info('AgeDetector stopped.');
    return null;
  }

  final Disposer _disposer = Disposer();
}
