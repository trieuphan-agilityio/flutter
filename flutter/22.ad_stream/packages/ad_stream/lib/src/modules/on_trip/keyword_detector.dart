import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';

abstract class KeywordDetector implements Service {
  Stream<List<Keyword>> get keywords$;
}

class KeywordDetectorImpl with ServiceMixin implements KeywordDetector {
  final StreamController<List<Keyword>> _controller;
  final Stream<String> text$;

  KeywordDetectorImpl(this.text$)
      : _controller = StreamController<List<Keyword>>.broadcast();

  Stream<List<Keyword>> get keywords$ => _controller.stream;

  @override
  Future<void> start() {
    super.start();

    Log.info('KeywordDetector started.');
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();

    Log.info('KeywordDetector stopped.');
    return null;
  }
}
