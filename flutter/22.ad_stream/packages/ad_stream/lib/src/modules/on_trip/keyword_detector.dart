import 'dart:async';

import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/ad/ad_repository.dart';
import 'package:ad_stream/src/modules/base/service.dart';

abstract class KeywordDetector implements Service {
  Stream<List<Keyword>> get keywords$;
}

class KeywordDetectorImpl with ServiceMixin implements KeywordDetector {
  final StreamController<List<Keyword>> _controller;
  final AdRepository adRepository;
  final Stream<String> text$;

  KeywordDetectorImpl(this.adRepository, this.text$)
      : _controller = StreamController<List<Keyword>>.broadcast();

  Stream<List<Keyword>> get keywords$ =>
      _keywords$ ??= _controller.stream.distinct();

  /// backing field of [keywords$].
  Stream<List<Keyword>> _keywords$;
}
