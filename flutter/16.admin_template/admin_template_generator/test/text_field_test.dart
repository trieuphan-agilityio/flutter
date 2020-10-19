import 'package:admin_template_generator/form/field.dart';
import 'package:test/test.dart';

main() {
  group('TextField', () {
    test('has default attributes', () {
      final textField = TextField('firstName', {});
      expect('', textField.toSource());
    });
  });
}
