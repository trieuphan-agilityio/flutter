import 'dart:async';

class Photo {
  /// Sometimes the photo is saved at cache folder so that it can be clean up by
  /// system's file manager.
  ///
  /// If the consumer use [Photo] and not seeing a valid [filePath], consumer
  /// should handle the error by itself.
  final String filePath;

  Photo(this.filePath);
}

abstract class CameraController {
  Stream<Photo> get photo$;
}

class CameraControllerImpl implements CameraController {
  /// A broadcast controller
  final StreamController<Photo> _controller;

  Stream<Photo> get photo$ => _controller.stream;

  CameraControllerImpl() : _controller = StreamController.broadcast();
}
