import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/processor/form_processor.dart';
import 'package:admin_template_generator/value_object/form.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build_test/build_test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  List<Form> forms;
  setUpAll(() async => forms = await _getForms());

  test('detect form fields from given model', () async {
    final nameElement = await _generateFieldElement('''
    final String name;
    ''');
    final ageElement = await _generateFieldElement('''
    int get age;
    ''');
    expect(forms.length, equals(1));
    expect(forms[0].model.fields.length, equals(2));
    expect(forms[0].model.fields[0].name, nameElement.displayName);
    expect(forms[0].model.fields[1].name, ageElement.displayName);
  });
}

Future<List<Form>> _getForms() async {
  final library = await resolveSource('''
    library test;
    
    import 'package:admin_template_annotation/admin_template_annotation.dart';
    
    abstract class Person {
      @AgText(required: true)
      final String name;
      
      @AgText()
      int get age;
      
      Person(this.name);
    }
    
    @AgForm(modelType: Person)
    abstract class PersonForm {}
    ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  return library.classes
      .where((element) => element.isAbstract)
      .where((element) =>
          TypeChecker.fromRuntime(AgForm).hasAnnotationOfExact(element))
      .map((element) => FormProcessor(element).process())
      .toList();
}

Future<FieldElement> _generateFieldElement(final String field) async {
  final library = await resolveSource('''
      library test;
      
      import 'package:admin_template_annotation/admin_template_annotation.dart';
      import 'dart:typed_data';
      
      class Foo {
        $field
      }
      ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  return library.classes.first.fields.first;
}
