import 'package:ad_bloc/base.dart';

/// Describe the state of trip whether not on trip or on trip, and how many
/// passenger on that trip.
class Trip {
  final Iterable<Face> passengers;

  /// An identity that represents for passengers on a trip.
  /// On trip, the first Face Id will be used until the trip is end.
  /// There is no further face detection once Face Id is set.
  Face get faceId => passengers.length > 1 ? passengers.first : null;

  const Trip._([this.passengers]);

  const factory Trip.offTrip() = Trip._;
  const factory Trip.onTrip(Iterable<Face> passengers) = Trip._;

  /// Device is considered on trip when Power is [PowerState.strong],
  /// face is found and there is movement.
  bool get isOnTrip => passengers != null && passengers.length > 0;
  bool get isOffTrip => passengers == null || passengers.length == 0;

  @override
  String toString() => 'Trip(passengers: $passengers)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is Trip && listEquals(o.passengers, passengers);
  }

  @override
  int get hashCode => passengers.hashCode;
}

/// [Photo] was taken by [CameraController]. It contains a [filePath] indicates
/// local filesystem's path of the captured photo.
class Photo {
  /// Sometimes the photo is saved at cache folder so that it can be clean up by
  /// system's file manager.
  ///
  /// If the consumer use [Photo] and not seeing a valid [filePath], consumer
  /// should handle the error by itself.
  final String filePath;

  const Photo(this.filePath);

  @override
  String toString() {
    return 'Photo{filePath: $filePath}';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Photo && o.filePath == filePath;
  }

  @override
  int get hashCode => filePath.hashCode;
}

class Face {
  /// An identifier that represents for a passenger on a trip.
  /// On trip, the first Face Id will be used until the trip is end.
  /// There is no further face detection once Face Id is set.
  final String id;

  /// Cropped portrait contains a full face.
  final Photo photo;

  const Face(this.id, this.photo);

  @override
  String toString() {
    return 'Face{id: $id, photo: $photo}';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Face && o.id == id && o.photo == photo;
  }

  @override
  int get hashCode => hash2(id, photo);
}
