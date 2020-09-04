import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:meta/meta.dart';

class GpsConfig {
  /// Time in seconds must elapse before [GpsController] repeatedly
  /// refresh its content.
  final int refreshInterval;

  /// Desired accuracy that uses to determine the gps data when on trip.
  final GpsAccuracy accuracyWhenOnTrip;

  /// The minimum distance (measured in meters) a device must move before
  /// an update event is generated when vehicle is on trip.
  final int distanceFilterWhenOnTrip;

  /// Desired accuracy that uses to determine the gps data when on trip.
  final GpsAccuracy accuracyWhenOffTrip;

  /// The minimum distance (measured in meters) a device must move before
  /// an update event is generated when vehicle is on trip.
  final int distanceFilterWhenOffTrip;

  GpsConfig({
    @required this.refreshInterval,
    @required this.accuracyWhenOnTrip,
    @required this.distanceFilterWhenOnTrip,
    @required this.accuracyWhenOffTrip,
    @required this.distanceFilterWhenOffTrip,
  });
}

abstract class GpsConfigProvider {
  GpsConfig get gpsConfig;
  Stream<GpsConfig> get gpsConfig$;
}
