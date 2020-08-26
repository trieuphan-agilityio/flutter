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
}

abstract class CameraController implements Service {
  Stream<Photo> get photo$;
}

class CameraControllerImpl with ServiceMixin implements CameraController {
  /// A broadcast controller
  final StreamController<Photo> _controller;

  Stream<Photo> get photo$ => _controller.stream;

  CameraControllerImpl(this._config)
      : _controller = StreamController.broadcast() {
    backgroundTask = ServiceTask(() {
      // FIXME
      _controller.add(Photo('sample/file.path'));
    }, _config.cameraCaptureInterval);
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
