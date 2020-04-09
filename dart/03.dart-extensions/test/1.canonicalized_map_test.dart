import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  group('CanonicalizedMap', () {
    CanonicalizedMap<int, String, String> map;

    setUp(() {
      map = CanonicalizedMap(int.parse,
          isValidKey: (s) => RegExp(r'^\d+$').hasMatch(s as String));
    });

    test('canonicalizes keys on set and get', () {
      map['1'] = 'value';
      expect(map['01'], equals('value'));
    });

    test('get returns null for uncanonicalizable key', () {
      expect(map['foo'], isNull);
    });

    test('set affects nothing for uncanonicalizable key', () {
      map['foo'] = 'value';
      expect(map['foo'], isNull);
      expect(map.containsKey('foo'), isFalse);
      expect(map.length, equals(0));
    });

    test('canonicalizes keys for addAll', () {
      map.addAll({'1': 'value 1', '2': 'value 2', '3': 'value 3'});
      expect(map['01'], equals('value 1'));
      expect(map['02'], equals('value 2'));
      expect(map['03'], equals('value 3'));
    });
  });
}
