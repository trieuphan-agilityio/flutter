import 'dart:async';

import 'mic_controller.dart';

abstract class SpeechToText {
  /// [text$] exposes processed
  Stream<String> get text$;
}

class SpeechToTextImpl implements SpeechToText {
  StreamController<String> _controller;

  SpeechToTextImpl(Stream<Audio> audio$)
      : _controller = StreamController.broadcast() {
    audio$.listen(_convert);
  }

  Stream<String> get text$ => _text$ ??= _controller.stream.distinct();

  /// Convert speech into text.
  ///
  /// [audio] is persist on cache storage, it's necessary to catch
  /// [FileSystemException] while accessing into [audio] file. The exception
  /// must be tolerated and the result will be null.
  ///
  /// Return null if any other exceptions happen.
  _convert(Audio audio) {
    // TODO needs implement
  }

  /// A cache instance of [text$]
  Stream<String> _text$;
}
