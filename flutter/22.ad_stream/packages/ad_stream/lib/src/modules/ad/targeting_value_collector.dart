import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
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
  /// Keep observing the [TripState] to determine when it should clean up
  /// [_targetingValues]. [TargetingValues] must not retain when trip is drop-off.
  Stream<TripState> _tripState$;

  /// Gender of passenger that was detected by [GenderDetector].
  Stream<PassengerGender> _gender$;

  /// Age of passenger that was detected by [AgeDetector].
  Stream<PassengerAgeRange> _ageRange$;

  /// Keywords that were derived from the conversation of passenger.
  Stream<List<Keyword>> _keywords$;

  /// Areas that were detected from [LatLng] value which reported by
  /// [GpsController].
  Stream<List<Area>> _areas$;

  TargetingValues _targetingValues;

  TargetingValueCollectorImpl(
    this._tripState$,
    this._gender$,
    this._ageRange$,
    this._keywords$,
    this._areas$,
  )   : _controller = StreamController<TargetingValues>.broadcast(),
        _targetingValues = TargetingValues();

  final StreamController<TargetingValues> _controller;

  Stream<TargetingValues> get targetingValues$ =>
      _targetingValues$ ??= _controller.stream;

  /// A buffer of targeting values, it collects all values and used for
  /// emitting to [targetingValues$] stream.
  Stream<TargetingValues> _targetingValues$;

  _addValue(TargetingValue value) {
    _targetingValues.add(value);
    _controller.add(_targetingValues);
  }

  _addListOfValues(List<TargetingValue> values) {
    _targetingValues.addAll(values);
    _controller.add(_targetingValues);
  }

  @override
  Future<void> start() {
    super.start();

    _disposer.autoDispose(_gender$.listen(_addValue));
    _disposer.autoDispose(_ageRange$.listen(_addValue));
    _disposer.autoDispose(_keywords$.listen(_addListOfValues));
    _disposer.autoDispose(_areas$.listen(_addListOfValues));

    _disposer.autoDispose(_tripState$.listen((tripState) {
      // when trip is dropped off, clear all targeting values.
      if (tripState == TripState.offTrip) {
        _targetingValues.clear();
      }
    }));

    Log.info('TargetingValueCollector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _disposer.cancel();

    Log.info('TargetingValueCollector stopped.');
    return null;
  }

  final Disposer _disposer = Disposer();
}
