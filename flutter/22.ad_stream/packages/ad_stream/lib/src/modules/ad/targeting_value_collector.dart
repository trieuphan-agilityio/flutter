import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
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
  /// Gender of passenger that was detected by [GenderDetector].
  Stream<PassengerGender> _gender$;

  /// Age of passenger that was detected by [AgeDetector].
  Stream<PassengerAgeRange> _ageRange$;

  /// Keywords that were derived from the conversation of passenger.
  Stream<List<Keyword>> _keywords$;

  /// Areas that were detected from [LatLng] value which reported by
  /// [GpsController].
  Stream<List<Area>> _areas$;

  TargetingValueCollectorImpl(
    this._gender$,
    this._ageRange$,
    this._keywords$,
    this._areas$,
  ) : _controller = StreamController<TargetingValues>.broadcast();

  final StreamController<TargetingValues> _controller;

  Stream<TargetingValues> get targetingValues$ =>
      _targetingValues$ ??= _controller.stream;

  Stream<TargetingValues> _targetingValues$;

  @override
  Future<void> start() {
    super.start();

    final subscription = CombineLatestStream.combine4(
      _gender$,
      _ageRange$,
      _keywords$,
      _areas$,
      (gender, ageRange, keywords, areas) {
        Log.debug('TargetingValueCollector observed'
            ' $gender, $ageRange, $keywords, $areas.');
        return TargetingValues()
          ..add(gender)
          ..add(ageRange)
          ..addAll(keywords)
          ..addAll(areas);
      },
    ).listen(_controller.add);

    _disposer.autoDispose(subscription);

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
