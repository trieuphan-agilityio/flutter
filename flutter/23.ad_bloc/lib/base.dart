import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:rxdart/rxdart.dart';

export 'dart:async';

export 'package:async/async.dart';
export 'package:collection/collection.dart' hide binarySearch, mergeSort;
export 'package:equatable/equatable.dart';
export 'package:flutter/foundation.dart';
export 'package:meta/meta.dart';
export 'package:quiver/core.dart';
export 'package:rxdart/rxdart.dart';
export 'package:stream_transform/stream_transform.dart';
export 'package:tuple/tuple.dart';

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

class SolarizedColor {
  static const base03 = Color.fromRGBO(0, 43, 54, 1);
  static const base02 = Color.fromRGBO(7, 54, 66, 1);
  static const base01 = Color.fromRGBO(88, 110, 117, 1);
  static const base00 = Color.fromRGBO(101, 123, 131, 1);
  static const base0 = Color.fromRGBO(131, 148, 150, 1);
  static const base1 = Color.fromRGBO(147, 161, 161, 1);
  static const base2 = Color.fromRGBO(238, 232, 213, 1);
  static const base3 = Color.fromRGBO(253, 246, 227, 1);
  static const yellow = Color.fromRGBO(181, 137, 0, 1);
  static const orange = Color.fromRGBO(203, 75, 22, 1);
  static const red = Color.fromRGBO(211, 1, 2, 1);
  static const magenta = Color.fromRGBO(211, 54, 130, 1);
  static const violet = Color.fromRGBO(108, 113, 196, 1);
  static const blue = Color.fromRGBO(38, 139, 210, 1);
  static const cyan = Color.fromRGBO(42, 161, 152, 1);
  static const green = Color.fromRGBO(133, 153, 0, 1);
}
