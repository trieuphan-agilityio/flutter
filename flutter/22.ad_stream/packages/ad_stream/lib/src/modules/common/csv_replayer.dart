import 'dart:async';

import 'package:ad_stream/base.dart';
import 'package:csv/csv.dart';

/// [CsvReplayer] loads a data script describes a stream with time and value.
///
/// The data script contains csv row format, for example:
///
/// 1000,a,b
/// 2000,c,d
/// 3000,e,f
/// ...
///
/// which mean that
///
/// after 1000ms the [csv$] stream will emit ['a', 'b'],
/// after 2000ms the [csv$] stream will emit ['c', 'd'],
/// after 3000ms the [csv$] stream will emit ['e', 'f'],
///
/// and so on.
///
class CsvReplayer {
  final _csvConverter = CsvToListConverter(eol: '\n');

  /// A well-defined csv text that contains rows in csv format.
  /// First item in each row contains a time offset which is integer value it indicates
  /// when the stream should emit this value.
  final String _raw;

  List<List<dynamic>> _csv;

  CsvReplayer(this._raw, {this.initialTimeOffset = 0})
      : _controller = StreamController<List<dynamic>>() {
    _csv = _csvConverter.convert(_raw);

    // verify the csv records
    _csv.asMap().forEach((index, row) {
      assert(_validateRowFormat(row) == true, 'Row $index is invalid.');
    });

    _controller.onListen = _start;
    _controller.onPause = _pause;
    _controller.onResume = _resume;
    _controller.onCancel = _stop;
  }

  final StreamController<List<dynamic>> _controller;

  /// A stream of events that are produced by this replayer.
  Stream<List<dynamic>> get csv$ => _controller.stream;

  // Represent the index that is recently emitted in stream
  int _cursor = 0;

  int initialTimeOffset;

  // Time offset that uses for scheduling next emit event.
  int _lastTimeOffset;

  /// [_completer]
  Completer _completer;
  Timer _timer;

  _start() {
    _cursor = 0;
    _lastTimeOffset = initialTimeOffset;
    _startAt(_cursor);
  }

  _startAt(int index) async {
    assert(
        index < _csv.length, 'index must be in range 0 - ${_csv.length - 1}');

    _cursor = index;
    _resetTimer();

    for (final row in _csv.sublist(index, _csv.length)) {
      int timeOffset = row[0];

      _completer = Completer();

      _timer = Timer(
        Duration(milliseconds: timeOffset - _lastTimeOffset),
        () {
          if (_completer.isCompleted) return;

          _completer.complete();
          _completer = null;
        },
      );

      try {
        await _completer.future;
        _controller.add(row.sublist(1, row.length));

        _cursor += 1;
        _lastTimeOffset = timeOffset;
      } catch (_) {
        // if the _running completer completed with error, which mean that the player
        // was paused or cancel, then it should not update any thing.

        // stop produce events if completer is instructed to complete with error.
        return;
      }
    }

    // finish stream.
    _controller.close();
  }

  _resetTimer() {
    _completer?.completeError(_CompleterError());
    _completer = null;

    _timer?.cancel();
    _timer = null;
  }

  _pause() {
    _resetTimer();
  }

  _resume() {
    _startAt(_cursor);
  }

  _stop() {
    _resetTimer();
    _cursor = 0;
    _lastTimeOffset = initialTimeOffset;
  }

  /// Return true if the row is valid.
  ///
  /// Valid row would be as below format:
  /// 1000,a1,b1
  ///
  /// + 1000 is the time offset, that indicates when value is emitted on stream
  ///
  /// + a1,b1 is the value, it could be more than 2 items and they should represent
  ///         as csv format
  bool _validateRowFormat(List<dynamic> row) {
    // A row must have at least two items.
    if (row.length < 2) return false;

    // First value in a row must be integer
    if (!(row[0] is int)) return false;

    return true;
  }

  @visibleForTesting
  int get cursor => _cursor;

  @visibleForTesting
  int get lastTimeOffset => _lastTimeOffset;

  @visibleForTesting
  Timer get timer => _timer;

  @visibleForTesting
  Completer get completer => _completer;
}

/// [_CompleterError] is used for controlling the data flow of [CsvReplayer].
/// It supposes to not contain any information when throwing.
class _CompleterError extends Error {}
