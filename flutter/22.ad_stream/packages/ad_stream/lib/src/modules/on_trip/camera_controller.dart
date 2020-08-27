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

  /// A flag to indicate whether the controller should capture image or not.
  /// When there is no subscriber or the subscription is paused, the controller
  /// should not do anything to prevent leaking resources.
  bool shouldCapture = false;

  CameraControllerImpl(this._config) : _controller = StreamController() {
    backgroundTask = ServiceTask(
      () async {
        // not capture image if the service is instructed to not do so.
        if (!shouldCapture) {
          Log.debug('CameraController beating');
          return;
        }

        final photo = await _capturePhoto();
        _controller.add(photo);

        Log.info('CameraController captured $photo.');
      },
      _config.cameraCaptureInterval,
    );

    _controller.onListen = () {
      Log.debug('CameraController was subscribed.');
      return shouldCapture = true;
    };
    _controller.onPause = () {
      Log.debug('CameraController paused subscription.');
      return shouldCapture = false;
    };
    _controller.onResume = () {
      Log.debug('CameraController resumed subscription.');
      return shouldCapture = true;
    };
    _controller.onCancel = () {
      Log.debug('CameraController canceled subscription.');
      return shouldCapture = false;
    };
  }

  Future<Photo> _capturePhoto() async {
    // FIXME
    return Photo('sample/file.path');
  }

  @override
  Future<void> start() {
    super.start();

    Log.info('CameraController started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();

    Log.info('CameraController stopped.');
    return null;
  }

  final Config _config;
}
