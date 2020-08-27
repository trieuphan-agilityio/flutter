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

  @override
  String toString() {
    return 'Face{id: $id, photo: $photo}';
  }
}

abstract class FaceDetector implements Service {
  Stream<List<Face>> get faces$;
}

class FaceDetectorImpl with ServiceMixin implements FaceDetector {
  StreamController<List<Face>> _controller;

  final Stream<Photo> _photo$;

  FaceDetectorImpl(this._photo$)
      : assert(
          !_photo$.isBroadcast,
          '_photo\$ must be single-subscription stream.',
        ),
        _controller = StreamController.broadcast();

  Stream<List<Face>> get faces$ => _controller.stream;

  _detectFaces(Photo photo) {
    // FIXME
    final faces = [Face('face-id', photo)];
    _controller.add(faces);

    Log.debug('FaceDetected detected '
        '${faces.length} ${faces.length > 1 ? "faces" : "face"}.');
  }

  @override
  Future<void> start() {
    super.start();

    if (_photo$Subscription == null) {
      _photo$Subscription = _photo$.listen(_detectFaces);
    } else if (_photo$Subscription.isPaused) {
      _photo$Subscription.resume();
    }

    Log.info('FaceDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();
    _photo$Subscription?.pause();

    Log.info('FaceDetector stopped.');
    return null;
  }

  StreamSubscription _photo$Subscription;
}
