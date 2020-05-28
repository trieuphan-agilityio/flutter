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
  test('Handle Text field annotation', () async {
    final fieldElement = await _generateFieldElement('''
    @AgText(required: false, initialValue: "", labelText: "Pet owner's name")
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
        FieldAttribute<String>(
            AnnotationField.initialValue, "model.name ?? ''"),
        FieldAttribute<String>(AnnotationField.labelText, "Pet owner's name"),
      ],
      formFieldAnnotation: formFieldAnnotation,
    );
    expect(actual, equals(expected));
  });

  test('Handle Email field annotation', () async {
    final fieldElement = await _generateFieldElement('''
    @AgEmail(
      required: true,
      hintText: "Your business email address",
      labelText: "E-mail",
    )
    final String email;
    ''');

    final actual = ModelFieldProcessor(fieldElement).process();

    const name = 'email';
    final formFieldAnnotation = fieldElement.getAnnotation(AgEmail);
    final expected = ModelField(
      fieldElement,
      name,
      attributes: [
        FieldAttribute<bool>(AnnotationField.required, true),
        FieldAttribute<String>(AnnotationField.initialValue, 'model.email'),
        FieldAttribute<String>(
            AnnotationField.hintText, "Your business email address"),
        FieldAttribute<String>(AnnotationField.labelText, "E-mail"),
        FieldAttribute<String>(AnnotationField.validator, """
        CompositeValidator(property: 'email', validators: [
          RequiredValidator(property: 'email'),
          EmailValidator(property: 'email'),
        ])
        """),
      ],
      formFieldAnnotation: formFieldAnnotation,
    );
    expect(actual, equals(expected));
  });

  test('Handle a field annotation with minLength attribute', () async {
    final fieldElement = await _generateFieldElement('''
    @AgPassword(
      minLength: 8,
      hintText: "Must have at least 8 characters.",
    )
    String get password;
    ''');

    final actual = ModelFieldProcessor(fieldElement).process();

    const name = 'password';
    final formFieldAnnotation = fieldElement.getAnnotation(AgPassword);
    final expected = ModelField(
      fieldElement,
      name,
      attributes: [
        FieldAttribute<String>(AnnotationField.initialValue, 'model.password'),
        FieldAttribute<String>(
            AnnotationField.hintText, 'Must have at least 8 characters.'),
        FieldAttribute<String>(AnnotationField.labelText, 'Password'),
        FieldAttribute<String>(AnnotationField.validator,
            'MinLengthValidator(8, property: \'password\')'),
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
