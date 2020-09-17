import 'package:ad_stream/base.dart';

import 'face.dart';

/// Describe the state of trip whether not on trip or on trip, and how many
/// passenger on that trip.
class TripState {
  final List<Face> passengers;

  const TripState._([this.passengers]);

  const factory TripState.offTrip() = TripState._;
  const factory TripState.onTrip(List<Face> passengers) = TripState._;

  /// Device is considered on trip when Power is [PowerState.strong],
  /// face is found and there is movement.
  bool get isOnTrip => passengers != null && passengers.length > 0;
  bool get isOffTrip => passengers == null || passengers.length == 0;

  @override
  String toString() => 'TripState(passengers: $passengers)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is TripState && listEquals(o.passengers, passengers);
  }

  @override
  int get hashCode => passengers.hashCode;
}
