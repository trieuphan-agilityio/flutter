import 'package:meta/meta.dart';

/// Represents different options to configure the quality and frequency
/// of location updates.
class GpsOptions {
  /// Initializes a new [GpsOptions] instance with default values.
  ///
  /// The following default values are used:
  /// - distanceFilter: 1
  const GpsOptions({@required this.accuracy, this.distanceFilter = 1});

  /// Defines the desired accuracy that should be used to determine the gps data.
  ///
  /// The default value for this field is [GpsAccuracy.best].
  final GpsAccuracy accuracy;

  /// The minimum distance (measured in meters) a device must move before
  /// an update event is generated.
  ///
  /// Supply 0 when you want to be notified of all movements.
  ///
  /// The default is 1.
  final int distanceFilter;
}

class GpsAccuracy {
  const GpsAccuracy._(this.value);

  /// The current gps accuracy value.
  final int value;

  /// Location is accurate within a distance of 500m
  static const GpsAccuracy low = GpsAccuracy._(1);

  /// Location is accurate within a distance of between 100m and 500m
  static const GpsAccuracy medium = GpsAccuracy._(2);

  /// Location is accurate within a distance of between 0m and 100m
  static const GpsAccuracy high = GpsAccuracy._(3);

  /// Location is accurate within a distance of between 0m and 100m
  static const GpsAccuracy best = GpsAccuracy._(4);

  /// List of all possible gps accuracy values.
  static const List<GpsAccuracy> values = <GpsAccuracy>[
    low,
    medium,
    high,
    best,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GpsAccuracy &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
