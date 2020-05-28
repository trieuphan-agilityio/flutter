import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/processor/model_processor.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build_test/build_test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  test('Scan form annotations on model fields', () async {
    final classElement = await _createClassElement('''
      class User {
        final int id;
        
        @AgText()
        final String name;
        
        @AgPassword()
        final String password;
        
        @AgBool(required: true, initialValue: true)
        final bool isAdmin;
        
        User(this.id, this.name, this.password, this.isAdmin);
      }
    ''');
    final actual = ModelProcessor(classElement).process();

    expect(actual.classElement, equals(classElement));
    expect(actual.name, equals('User'));
    expect(actual.fields.length, equals(3));
    expect(actual.fields[0].name, equals('name'));
    expect(actual.fields[2].name, equals('isAdmin'));
    expect(
        actual.fields[2].attributes,
        equals([
          FieldAttribute<bool>(FieldAnnotation.required, true),
          FieldAttribute<String>(
              FieldAnnotation.initialValue, 'model.isAdmin || true'),
          FieldAttribute<String>(FieldAnnotation.labelText, 'Is Admin'),
        ]));
  });
}

Future<ClassElement> _createClassElement(final String clazz) async {
  final library = await resolveSource('''
      library test;
      
      import 'package:admin_template_annotation/admin_template_annotation.dart';
      
      $clazz
      ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  return library.classes.first;
}
