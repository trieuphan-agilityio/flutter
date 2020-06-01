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
        FieldAttribute<bool>(FieldAnnotation.required, false),
        FieldAttribute<String>(
            FieldAnnotation.initialValue, "model.name ?? ''"),
        FieldAttribute<String>(FieldAnnotation.labelText, "Pet owner's name"),
        FieldAttribute<String>(FieldAnnotation.onSaved,
            '(newValue) { model = model.rebuild((b) => b.name = newValue); }'),
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

    expect(actual.fieldElement, equals(fieldElement));
    expect(actual.name, equals(name));
    expect(
      actual.attributes,
      unorderedEquals([
        FieldAttribute<String>(FieldAnnotation.initialValue, 'model.email'),
        FieldAttribute<String>(
            FieldAnnotation.hintText, 'Your business email address'),
        FieldAttribute<String>(FieldAnnotation.labelText, 'E-mail'),
        FieldAttribute<String>(FieldAnnotation.onSaved,
            '(newValue) { model = model.rebuild((b) => b.email = newValue); }'),
        FieldAttribute<String>(FieldAnnotation.validator, """
        CompositeValidator(property: 'email', validators: [
          RequiredValidator(property: 'email'),
          EmailValidator(property: 'email'),
        ])
        """),
      ]),
    );

    expect(actual.formFieldAnnotation, equals(formFieldAnnotation));
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
    final formFieldAnnotation = fieldElement.getter.getAnnotation(AgPassword);

    expect(actual.fieldElement, equals(fieldElement));
    expect(actual.name, equals(name));
    expect(
      actual.attributes,
      unorderedEquals([
        FieldAttribute<String>(FieldAnnotation.initialValue, 'model.password'),
        FieldAttribute<String>(
            FieldAnnotation.hintText, 'Must have at least 8 characters.'),
        FieldAttribute<String>(FieldAnnotation.labelText, 'Password'),
        FieldAttribute<String>(FieldAnnotation.validator,
            'MinLengthValidator(8, property: \'password\')'),
        FieldAttribute<String>(FieldAnnotation.onSaved,
            '(newValue) { model = model.rebuild((b) => b.password = newValue); }')
      ]),
    );
    expect(actual.formFieldAnnotation, equals(formFieldAnnotation));
  });

  test('Handle List field annotation', () async {
    final fieldElement = await _generateFieldElement('''
    @AgList(
      choices: const [AnswerItem.A, AnswerItem.B],
      helperText: "Choose A, B or both.",
    )
    BuiltList<AnswerItem> get answer;
    ''');

    final actual = ModelFieldProcessor(fieldElement).process();

    final expectedAttrs = [
      FieldAttribute<List<String>>(FieldAnnotation.choices, ['A', 'B']),
      FieldAttribute<String>(FieldMetadata.choiceType, 'AnswerItem'),
      FieldAttribute<String>(FieldAnnotation.initialValue, 'model.answer'),
      FieldAttribute<String>(
          FieldAnnotation.helperText, 'Choose A, B or both.'),
      FieldAttribute<String>(FieldAnnotation.labelText, 'Answer'),
      FieldAttribute<String>(
        FieldAnnotation.onSaved,
        '(newValue) { model = model.rebuild((b) => b.answer = newValue); }',
      ),
    ];

    expect(actual.name, equals('answer'));
    expect(actual.attributes, unorderedEquals(expectedAttrs));
    expect(
      actual.formFieldAnnotation,
      equals(fieldElement.getter.getAnnotation(AgList)),
    );
  });
}

Future<FieldElement> _generateFieldElement(final String field) async {
  final library = await resolveSource(
    '''
    library test;
    
    import 'package:admin_template_annotation/admin_template_annotation.dart';
    import 'package:built_collection/built_collection.dart';
    import 'package:built_value/built_value.dart';
    import 'dart:typed_data';
    
    abstract class Foo {
      $field
    }
    
    class AnswerItem extends EnumClass {
      const AnswerItem._(String name) : super(name);
      static const AnswerItem A = AnswerItem._('A');
      static const AnswerItem B = AnswerItem._('B');
    }
    ''',
    (resolver) async {
      return LibraryReader(await resolver.findLibraryByName('test'));
    },
  );

  return library.classes.first.fields.first;
}
