import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/movement_status.dart';
import 'package:ad_stream/src/modules/on_trip/camera_controller.dart';
import 'package:ad_stream/src/modules/on_trip/trip_detector.dart';
import 'package:ad_stream/src/modules/base/service.dart';
import 'package:crypto/crypto.dart';

import 'face.dart';
import 'photo.dart';
import 'trip_state.dart';

/// [FaceDetector] provides detected faces.
abstract class FaceDetector implements Service {
  Stream<List<Face>> get faces$;

  /// Allow breaking 2-ways dependent between [FaceDetector] and [TripDetector].
  /// [TripDetector] will invoke this method to supply [tripState$].
  attachTripState(Stream<TripState> tripState$);
}

/// [FaceDetectorImpl] provides detected faces from [_photo$] of [CameraController].
///
/// It also controls the usage of camera via single-subcription stream.
/// When there is no need to use camera it will pause the subscription.
/// When it needs camera to take photo it will resume the subscription.
///
/// The need of using camera depends on the movement state and trip state.
/// If it's on trip, camera is stopped.
/// If it's not movement, camera is stopped as wel.
/// Otherwise, it will actively use camera to take photo and detect face
class FaceDetectorImpl with ServiceMixin implements FaceDetector {
  FaceDetectorImpl(
    this._movementState$,
    this._photo$,
  ) : assert(
          !_photo$.isBroadcast,
          '_photo\$ must be single-subscription stream.',
        ) {
    _movementState$.listen((newValue) {
      _movementState = newValue;
      _verifyState();
    });
  }

  final Stream<MovementState> _movementState$;
  final Stream<Photo> _photo$;

  TripState _tripState;
  MovementState _movementState;

  StreamController<List<Face>> _controller = StreamController.broadcast();
  Stream<List<Face>> get faces$ => _controller.stream;

  _detectFaces(Photo photo) {
    /// Dummy detection that recognize faces based on photo's file path
    Iterable<Face> faces;
    final femalePhoto = Photo('face-sample-female-26_30.png');
    final malePhoto = Photo('face-sample-male-18_25.png');

    if (photo.filePath.contains('sample_1')) {
      faces = [
        Face(_genFaceId(femalePhoto), femalePhoto),
        Face(_genFaceId(malePhoto), malePhoto),
      ];
    } else if (photo.filePath.contains('sample_2')) {
      faces = [
        Face(_genFaceId(femalePhoto), femalePhoto),
      ];
    } else if (photo.filePath.contains('sample_3')) {
      faces = [
        Face(_genFaceId(malePhoto), malePhoto),
      ];
    } else {
      faces = [];
    }

    _controller.add(faces);

    Log.debug('FaceDetected detected '
        '${faces.length} ${faces.length > 1 ? "faces" : "face"}.');
  }

  _verifyState() {
    // Stop face detection once on trip. During the trip, use one FaceId was
    // detected from the start.
    if (_tripState != null && _tripState.isOnTrip) {
      if (!isStopped) stop();
      return;
    }

    // vehicle is not moving then stop the face detection.
    if (_movementState == MovementState.notMoving) {
      if (!isStopped) stop();
      return;
    }

    if (!isStarted) start();
  }

  /// Once attached with [$tripState$], [FaceDetector] can observe the state and
  /// call stop when TripState is [TripState.onTrip] which can help to optimize
  /// the usage of camera.
  attachTripState(Stream<TripState> tripState$) {
    tripState$.listen((newValue) {
      _tripState = newValue;
      _verifyState();
    });
  }

  @override
  start() async {
    super.start();

    if (_photo$Subscription == null) {
      _photo$Subscription = _photo$.listen(_detectFaces);
    } else if (_photo$Subscription.isPaused) {
      _photo$Subscription.resume();
    }
  }

  @override
  stop() async {
    super.stop();

    // FaceDetector is bit different to other services since it's consuming a
    // very expensive resource, camera. So it's using single-subscription stream
    // interface to instruct [CameraController] to pause the process when
    // no longer used.
    _photo$Subscription?.pause();
  }

  /// Create an unique face id for the given photo
  String _genFaceId(Photo photo) {
    /// make an unique string using photo's data
    return sha1.convert(utf8.encode(photo.filePath)).toString().substring(0, 5);
  }

  StreamSubscription _photo$Subscription;
}
