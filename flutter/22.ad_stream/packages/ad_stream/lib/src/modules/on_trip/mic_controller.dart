import 'dart:async';

class Audio {
  /// An identifier of [Audio].
  final String id;

  /// Typical the audio file is saved at cache folder so that it can automatically
  /// be clean up by system file manager.
  ///
  /// If consumer use [Audio] and not seeing a valid [filePath], consumer
  /// should handle the error by itself.
  final Audio filePath;

  Audio(this.id, this.filePath);
}

abstract class MicController {
  Stream<Audio> get audio$;
}

class MicControllerImpl implements MicController {
  final StreamController<Audio> _controller;

  MicControllerImpl() : _controller = StreamController.broadcast();

  Stream<Audio> get audio$ => _controller.stream;
}
