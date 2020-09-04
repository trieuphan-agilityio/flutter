import 'package:ad_stream/config.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/on_trip/trip_state.dart';
import 'package:rxdart/subjects.dart';

import 'gps_options.dart';

abstract class GpsOptionsProvider {
  /// The current [GpsOptions].
  GpsOptions get lastGpsOptions;

  /// Provide a stream to realtime update [GpsOptions].
  Stream<GpsOptions> get gpsOptions$;

  /// Break 2-ways dependent between [GpsOptionsProvider] and [TripDetector].
  /// [TripDetector] will invoke this method to supply [tripState$].
  attachTripState(Stream<TripState> tripState$);
}

class GpsOptionsProviderImpl implements GpsOptionsProvider {
  GpsOptionsProviderImpl(this.gpsConfigProvider)
      : subject = BehaviorSubject<GpsOptions>();

  final GpsConfigProvider gpsConfigProvider;
  final BehaviorSubject<GpsOptions> subject;

  GpsOptions get lastGpsOptions => subject.value;

  Stream<GpsOptions> get gpsOptions$ =>
      _gpsOptions$ ??= subject.stream.distinct();

  attachTripState(Stream<TripState> tripState$) {
    tripState$.listen((tripState) {
      if (tripState.isOffTrip) {
        subject.add(GpsOptions(
          accuracy: gpsConfigProvider.gpsConfig.accuracyWhenOnTrip,
          distanceFilter: gpsConfigProvider.gpsConfig.distanceFilterWhenOnTrip,
        ));
      } else if (tripState.isOnTrip) {
        subject.add(GpsOptions(
          accuracy: gpsConfigProvider.gpsConfig.accuracyWhenOffTrip,
          distanceFilter: gpsConfigProvider.gpsConfig.distanceFilterWhenOffTrip,
        ));
      }
    });
  }

  /// backing field of [gpsOptions$]
  Stream<GpsOptions> _gpsOptions$;
}
