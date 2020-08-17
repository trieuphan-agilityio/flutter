import 'dart:async';

import 'package:ad_stream/src/modules/on_trip/camera_controller.dart';

class Face {
  /// An identifier that represents for a passenger on a trip.
  /// On trip, the first Face Id will be used until the trip is end.
  /// There is no further face detection once Face Id is set.
  final String id;

  /// Cropped portrait contains a full face.
  final Photo photo;

  Face(this.id, this.photo);
}

abstract class FaceDetector {
  Stream<List<Face>> get faces$;
}

class FaceDetectorImpl implements FaceDetector {
  StreamController<List<Face>> _controller;

  FaceDetectorImpl(Stream<Photo> photo$)
      : _controller = StreamController.broadcast() {
    photo$.listen(_detectFaces);
  }

  Stream<List<Face>> get faces$ => _controller.stream;

  _detectFaces(Photo photo) {
    // TODO needs implement
  }
}
