import 'package:ad_stream/base.dart';

import 'photo.dart';

class Face {
  /// An identifier that represents for a passenger on a trip.
  /// On trip, the first Face Id will be used until the trip is end.
  /// There is no further face detection once Face Id is set.
  final String id;

  /// Cropped portrait contains a full face.
  final Photo photo;

  Face(this.id, this.photo);

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
