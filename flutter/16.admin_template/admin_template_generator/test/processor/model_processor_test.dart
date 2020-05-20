import 'package:admin_template_generator/processor/model_field_processor.dart';
import 'package:admin_template_generator/processor/model_processor.dart';
import 'package:admin_template_generator/value_object/model.dart';
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
        
        Person(this.id, this.name);
      }
    ''');
    final actual = ModelProcessor(classElement).process();

    const name = 'User';
    final modelFields = classElement.fields
        .map((fieldElement) => ModelFieldProcessor(fieldElement).process())
        .toList();
    final expected = Model(
      classElement,
      name,
      modelFields,
    );

    expect(actual, equals(expected));
  });
}

Future<ClassElement> _createClassElement(final String clazz) async {
  final library = await resolveSource('''
      library test;
      
      import 'package:floor_annotation/floor_annotation.dart';
      
      $clazz
      ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  return library.classes.first;
}
