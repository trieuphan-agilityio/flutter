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

  @override
  start() async {
    super.start();

    final subscription = text$.listen((text) async {
      // derives words from the sentence
      final words = text
          .split(' ')
          .map((word) => word.replaceAll(RegExp(r'(,|.|!|~)'), ''))
          .toList();

      final keywords = await adRepository.getKeywords();
      final matchedKeywords = [];

      // try to match derived words with keywords from ad repository
      for (final word in words) {
        if (keywords.contains(word)) {
          matchedKeywords.add(word);
        }
      }

      // emit if keywords are found
      if (matchedKeywords.length > 0) {
        _controller.add(matchedKeywords);
      }
    });

    disposer.autoDispose(subscription);
  }

  /// backing field of [keywords$].
  Stream<List<Keyword>> _keywords$;
}
