import 'dart:async';

import 'package:ad_stream/models.dart';

abstract class KeywordDetector {
  Stream<List<Keyword>> get keywords$;
}

class KeywordDetectorImpl implements KeywordDetector {
  final StreamController<List<Keyword>> _controller;
  final Stream<String> text$;

  KeywordDetectorImpl(this.text$)
      : _controller = StreamController<List<Keyword>>.broadcast();

  Stream<List<Keyword>> get keywords$ => _controller.stream;
}
