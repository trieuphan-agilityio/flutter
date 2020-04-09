import 'package:built_collection/built_collection.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltList', () {
    test('copies from BuiltList instances of different type', () {
      var list1 = BuiltList<Object>();
      var list2 = BuiltList<int>(list1);
      expect(list1, isNot(same(list2)));
    });

    test('can be converted to ListBuilder<E> and back to List<E>', () {
      expect(BuiltList<int>().toBuilder().build() is BuiltList<int>, isTrue);
      expect(
          BuiltList<int>().toBuilder().build() is BuiltList<String>, isFalse);
    });

    test('hashes to same value for same contents', () {
      var list1 = BuiltList<int>([1, 2, 3]);
      var list2 = BuiltList<int>([1, 2, 3]);

      expect(list1.hashCode, list2.hashCode);
    });

    test('has rebuild method', () {
      expect(BuiltList<int>([0, 1, 2]).rebuild((b) => b.addAll([3, 4, 5])),
          [0, 1, 2, 3, 4, 5]);
    });
  });

  group('ListBuilder', () {
    test('has a method like List.retainWhere', () {
      expect(
          (ListBuilder<int>([1, 2])..retainWhere((x) => x == 1)).build(), [1]);
      expect(
          (BuiltList<int>([1, 2]).toBuilder()..retainWhere((x) => x == 1))
              .build(),
          [1]);
    });
  });
}
