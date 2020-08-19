import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

/// keep latest 100 log items in the buffer to get ready for new subscriber.
const _kMaxLogsInBuffer = 100;

class Log {
  static Log _shared;

  factory Log() {
    return _shared ??= Log._();
  }

  final StreamController<String> _controller;
  Log._() : _controller = ReplaySubject<String>(maxSize: _kMaxLogsInBuffer);

  static debug(Object object) {
    String line = object.toString();
    Log()._controller.add("[D] $line");
  }

  static info(Object object) {
    String line = object.toString();
    Log()._controller.add("[I] $line");
  }

  static warn(Object object) {
    String line = object.toString();
    Log()._controller.add("[W] $line");
  }

  static Stream<String> get log$ => Log()._controller.stream;

  static Stream<List<String>> get last$ {
    if (_last$ == null) {
      final previousLogs = Queue<String>();
      _last$ = Log()
          ._controller
          .stream
          .transform(StreamTransformer.fromHandlers(handleData: (log, sink) {
        /// keep latest 100 items in the queue
        final numOfLogs = previousLogs.length;
        if (numOfLogs <= _kMaxLogsInBuffer) {
          if (numOfLogs == _kMaxLogsInBuffer) previousLogs.removeLast();
          previousLogs.addFirst(log);
          sink.add(previousLogs.toList(growable: false));
        }
      }));
    }

    return _last$;
  }

  /// backing field of [last$]
  static Stream<List<String>> _last$;
}
