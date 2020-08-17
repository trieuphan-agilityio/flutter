import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/speech_to_text.dart';

abstract class KeywordDetector {
  Stream<List<Keyword>> get keywords$;
}

class KeywordDetectorImpl implements KeywordDetector {
  final StreamController<List<Keyword>> _controller;
  final SpeechToText speechToText;

  KeywordDetectorImpl(this.speechToText)
      : _controller = StreamController<List<Keyword>>.broadcast();

  Stream<List<Keyword>> get keywords$ => _controller.stream;
}
