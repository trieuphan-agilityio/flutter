import 'dart:async';

import 'package:ad_stream/src/modules/common/csv_replayer.dart';
import 'package:fake_async/fake_async.dart';
import 'package:quiver/time.dart';
import 'package:test/test.dart';

main() {
  final _csv = '''999,a1,b1
1999,a2,b2
2999,a3,b3''';

  CsvReplayer csvReplayer;
  List<List<dynamic>> emittedValues;
  List<String> errors;
  bool isDone;
  StreamSubscription<List<dynamic>> subscription;

  group('CsvReplayer', () {
    setUp(() {
      emittedValues = [];
      errors = [];
      isDone = false;

      csvReplayer = CsvReplayer(_csv);
      subscription = null;
    });

    test('do not produce event if there is no subscriber', () {
      fakeAsync((async) {
        async.elapse(aMinute);

        expect(emittedValues, []);
        expect(errors, []);
        expect(isDone, false);
      });
    });

    test('continue at the last cursor when subscription is resumed', () {
      fakeAsync((async) {
        subscription = csvReplayer.csv$.listen(
          emittedValues.add,
          onError: errors.add,
          onDone: () => isDone = true,
        );

        async.elapse(aSecond);

        expect(emittedValues, [
          ['a1', 'b1']
        ]);
        expect(errors, []);
        expect(isDone, false);

        subscription.pause();
        async.elapse(aMinute);

        expect(emittedValues, [
          ['a1', 'b1']
        ]);
        expect(errors, []);
        expect(isDone, false);

        subscription.resume();
        async.elapse(aMinute);

        expect(emittedValues, [
          ['a1', 'b1'],
          ['a2', 'b2'],
          ['a3', 'b3']
        ]);
        expect(errors, []);
        expect(isDone, true);
      });
    });

    test('is stopped when subscription is cancel', () {
      fakeAsync((async) {
        subscription = csvReplayer.csv$.listen(
          emittedValues.add,
          onError: errors.add,
          onDone: () => isDone = true,
        );

        async.elapse(aSecond);

        expect(emittedValues, [
          ['a1', 'b1'],
        ]);
        expect(errors, []);
        expect(isDone, false);

        // then cancel
        subscription.cancel();
        async.elapse(aSecond);

        expect(emittedValues, [
          ['a1', 'b1'],
        ]);
        expect(errors, []);
        expect(isDone, false);
        expect(csvReplayer.cursor, 0);
        expect(csvReplayer.lastTimeOffset, csvReplayer.initialTimeOffset);
        expect(csvReplayer.timer, null);
        expect(csvReplayer.completer, null);
      });
    });

    test('emit done events when latest value is reached', () {
      fakeAsync((async) {
        csvReplayer.csv$.listen(
          emittedValues.add,
          onError: errors.add,
          onDone: () => isDone = true,
        );

        async.elapse(aMinute);

        expect(emittedValues, [
          ['a1', 'b1'],
          ['a2', 'b2'],
          ['a3', 'b3']
        ]);
        expect(errors, []);
        expect(isDone, true);
      });
    });
  });
}
