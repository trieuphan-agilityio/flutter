import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/on_trip/camera_controller.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

class Face {
  /// An identifier that represents for a passenger on a trip.
  /// On trip, the first Face Id will be used until the trip is end.
  /// There is no further face detection once Face Id is set.
  final String id;

  /// Cropped portrait contains a full face.
  final Photo photo;

  Face(this.id, this.photo);
}

abstract class FaceDetector implements Service {
  Stream<List<Face>> get faces$;
}

class FaceDetectorImpl with ServiceMixin implements FaceDetector {
  StreamController<List<Face>> _controller;

  final Stream<Photo> _photo$;

  FaceDetectorImpl(this._photo$) : _controller = StreamController.broadcast();

  Stream<List<Face>> get faces$ => _controller.stream;

  _detectFaces(Photo photo) {
    // FIXME
    _controller.add([Face('face-id', photo)]);
  }

  @override
  Future<void> start() {
    super.start();

    final subscription = _photo$.listen(_detectFaces);
    _disposer.autoDispose(subscription);

    Log.info('FaceDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _disposer.cancel();

    Log.info('FaceDetector stopped.');
    return null;
  }

  final Disposer _disposer = Disposer();
}
