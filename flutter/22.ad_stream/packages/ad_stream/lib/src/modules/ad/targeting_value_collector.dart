import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/age_detector.dart';
import 'package:ad_stream/src/modules/on_trip/face.dart';
import 'package:ad_stream/src/modules/on_trip/gender_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_state.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:rxdart/rxdart.dart';

/// A central collector that communicate with other collectors such as
/// [AgeCollector] and [AreaCollector] to combine to a collection of
/// [TargetingValue].
abstract class TargetingValueCollector implements Service {
  Stream<TargetingValues> get targetingValues$;
}

class TargetingValueCollectorImpl
    with ServiceMixin
    implements TargetingValueCollector {
  GenderDetector _genderDetector;
  AgeDetector _ageDetector;

  /// Keep observing the [TripState] to determine when it should clean up
  /// [_targetingValues]. [TargetingValues] must not retain when trip is drop-off.
  Stream<TripState> _tripState$;

  /// Keywords that were derived from the conversation of passenger.
  Stream<List<Keyword>> _keywords$;

  /// Areas that were detected from [LatLng] value which reported by
  /// [GpsController].
  Stream<List<Area>> _areas$;

  TargetingValues _targetingValues;

  TargetingValueCollectorImpl(
    this._genderDetector,
    this._ageDetector,
    this._tripState$,
    this._keywords$,
    this._areas$,
  )   : _subject = BehaviorSubject<TargetingValues>.seeded(TargetingValues()),
        _targetingValues = TargetingValues();

  final BehaviorSubject<TargetingValues> _subject;

  Stream<TargetingValues> get targetingValues$ =>
      _targetingValues$ ??= _subject.stream;

  /// A buffer of targeting values, it collects all values and used for
  /// emitting to [targetingValues$] stream.
  Stream<TargetingValues> _targetingValues$;

  _addValue(TargetingValue value) {
    _targetingValues.add(value);
    _subject.add(_targetingValues);
  }

  _addListOfValues(List<TargetingValue> values) {
    _targetingValues.addAll(values);
    _subject.add(_targetingValues);
  }

  @override
  start() async {
    super.start();

    disposer.autoDispose(_keywords$.listen(_addListOfValues));
    disposer.autoDispose(_areas$.listen(_addListOfValues));

    disposer.autoDispose(_tripState$.listen((tripState) {
      _currentTripState = tripState;

      if (tripState.isOnTrip) {
        _detectAgeRange(tripState.passengers);
        _detectGender(tripState.passengers);
        return;
      }

      // when trip is dropped off, clear all targeting values.
      if (tripState.isOffTrip) {
        _targetingValues.clear();
      }
    }));
  }

  _detectAgeRange(Iterable<Face> faces) {
    faces.forEach((face) async {
      final ageRange = await _ageDetector.detect(face);
      // report age range value if is on trip
      if (_currentTripState != null && _currentTripState.isOnTrip) {
        _addValue(ageRange);
      }
    });
  }

  _detectGender(Iterable<Face> faces) {
    faces.forEach((face) async {
      final gender = await _genderDetector.detect(face);
      // report gender value if is on trip
      if (_currentTripState != null && _currentTripState.isOnTrip) {
        _addValue(gender);
      }
    });
  }

  /// Keep a reference to current [TripState] so that collector can decide to
  /// accept or reject asynchronous results from [AgeDetector] and
  /// [GenderDetector].
  TripState _currentTripState;
}
