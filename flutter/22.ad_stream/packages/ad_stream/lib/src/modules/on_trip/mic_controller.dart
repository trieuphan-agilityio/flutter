import 'dart:async';

import 'package:ad_stream/config.dart';
import 'package:ad_stream/src/modules/base/service.dart';

class Audio {
  /// Typical the audio file is saved at cache folder so that it can automatically
  /// be clean up by system file manager.
  ///
  /// If consumer use [Audio] and not seeing a valid [filePath], consumer
  /// should handle the error by itself.
  final String filePath;

  Audio(this.filePath);
}

abstract class MicController implements Service {
  Stream<Audio> get audio$;
}

class MicControllerImpl with ServiceMixin implements MicController {
  MicControllerImpl(this._configProvider) : _controller = StreamController() {
    backgroundTask = ServiceTask(
      () async {
        final audio = await _recordAudio();
        _controller.add(audio);

        // Log.info('MicController recorded $audio.');
      },
      _configProvider.micConfig.recordInterval,
    );

    _configProvider.micConfig$.listen((config) {
      backgroundTask?.refreshIntervalSecs = config.recordInterval;
    });

    /// When there is no subscriber or the subscription is paused, the service
    /// must be stopped and the controller should not do anything to
    /// prevent leaking resources.
    _controller.onListen = start;
    _controller.onPause = stop;
    _controller.onResume = start;
    _controller.onCancel = stop;
  }

  /// A single-subscription stream controller.
  /// It will record audio only when there is a subscriber.
  final StreamController<Audio> _controller;

  Stream<Audio> get audio$ => _controller.stream;

  Future<Audio> _recordAudio() async {
    // FIXME
    return Audio('sample/file.path');
  }

  final MicConfigProvider _configProvider;
}
