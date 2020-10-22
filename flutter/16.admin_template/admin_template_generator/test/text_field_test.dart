import 'package:admin_template_generator/src/input/form_field_input.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build_test/build_test.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

import 'util.dart';

main() {
  useDartfmt();

  group('TextField', () {
    test('has default attributes', () async {
      final input = await _makeFormFieldInput(
        'AgFieldTemplate<String> get name => AgFieldTemplate((b) => b));',
      );

      expect(
          input.toFormField().toWidgetExpression(),
          equalsDart(
            "AgTextField("
            "initialValue: model.name,"
            " onSaved: (newValue) {"
            "  model = model.copyWith(name: newValue);"
            " } )",
          ));
    });

    test('has isRequired attribute', () async {
      final input = await _makeFormFieldInput(
        """
AgFieldTemplate<String> get name => AgFieldTemplate((b) => b
  ..isRequired = true);
""",
      );

      expect(
          input.toFormField().toWidgetExpression(),
          equalsDart(
            "AgTextField("
            "validator: const RequiredValidator(property: 'name'),"
            " initialValue: model.name,"
            " onSaved: (newValue) {"
            "  model = model.copyWith(name: newValue);"
            " } )",
          ));
    });

    test('has String-type attribute', () async {
      final input = await _makeFormFieldInput(
        """
AgFieldTemplate<String> get name => AgFieldTemplate((b) => b
  ..isRequired = true
  ..labelText = 'E-mail');
""",
      );

      expect(
          input.toFormField().toWidgetExpression(),
          equalsDart(
            "AgTextField("
            "validator: const RequiredValidator(property: 'name'),"
            " labelText: 'E-mail',"
            " initialValue: model.name,"
            " onSaved: (newValue) {"
            "  model = model.copyWith(name: newValue);"
            " } )",
          ));
    });
  });
}

Future<FormFieldInput> _makeFormFieldInput(String field) async {
  final fieldElement = await _makeFieldElement(field);
  final parsedLibrary = fieldElement.session.getParsedLibraryByElement(
    fieldElement.library,
  );
  return FormFieldInput(parsedLibrary, fieldElement);
}

Future<FieldElement> _makeFieldElement(String field) async {
  final library = await resolveSource("""
    library test;
    
    import 'package:admin_template_core/core.dart';
    
    class Foo {
      $field
    }
    """, (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });
  return library.classes.first.fields.first;
}
