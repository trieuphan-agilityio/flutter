import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

class Photo {
  /// Sometimes the photo is saved at cache folder so that it can be clean up by
  /// system's file manager.
  ///
  /// If the consumer use [Photo] and not seeing a valid [filePath], consumer
  /// should handle the error by itself.
  final String filePath;

  Photo(this.filePath);

  @override
  String toString() {
    return 'Photo{filePath: $filePath}';
  }
}

abstract class CameraController implements Service {
  Stream<Photo> get photo$;
}

class CameraControllerImpl with ServiceMixin implements CameraController {
  /// A single-subscription stream controller.
  /// It will capture image only when there is a subscriber.
  final StreamController<Photo> _controller;

  Stream<Photo> get photo$ => _controller.stream;

  CameraControllerImpl(this._config) : _controller = StreamController() {
    backgroundTask = ServiceTask(
      () async {
        final photo = await _capturePhoto();
        _controller.add(photo);

        Log.info('CameraController captured $photo.');
      },
      _config.cameraCaptureInterval,
    );

    /// When there is no subscriber or the subscription is paused, the service
    /// must be stopped and the controller should not do anything to
    /// prevent leaking resources.
    _controller.onListen = start;
    _controller.onPause = stop;
    _controller.onResume = start;
    _controller.onCancel = stop;
  }

  Future<Photo> _capturePhoto() async {
    // FIXME
    return Photo('sample/file.path');
  }

  final Config _config;
}
