import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/misc/type_utils.dart';
import 'package:admin_template_generator/processor/model_field_processor.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build_test/build_test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  test('Process form field annotation', () async {
    final fieldElement = await _generateFieldElement('''
      @AgText(required: false, initialValue: "", labelText: "Pet owner\'s name")
      final String name;
    ''');

    final actual = ModelFieldProcessor(fieldElement).process();

    const name = 'name';
    final formFieldAnnotation = fieldElement.getAnnotation(AgText);
    final expected = ModelField(
      fieldElement,
      name,
      attributes: [
        FieldAttribute<bool>(AnnotationField.required, false),
        FieldAttribute<String>(AnnotationField.initialValue, ''),
        FieldAttribute<String>(AnnotationField.labelText, 'Pet owner\'s name'),
      ],
      formFieldAnnotation: formFieldAnnotation,
    );
    expect(actual, equals(expected));
  });
}

Future<FieldElement> _generateFieldElement(final String field) async {
  final library = await resolveSource('''
      library test;
      
      import 'package:admin_template_annotation/admin_template_annotation.dart';
      import 'dart:typed_data';
      
      abstract class Foo {
        $field
      }
      ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  return library.classes.first.fields.first;
}
