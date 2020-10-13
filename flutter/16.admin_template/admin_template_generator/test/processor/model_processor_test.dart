import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/processor/model_processor.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
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

  test('Scan implementors of AgForm<T>', () async {
    final libraryElement = await _createClassElement('''
      class EditorAddForm implements AddForm<Editor> {
        FormField<String> get firstName {
          final builder = FieldBuilder<String>()
            ..isRequired = true
            ..helperText = 'Editor\'s first name';

          return builder.build();
        }

        FormField<String> get bio {
          final builder = FieldBuilder<String>()
            ..maxLength = 150
            ..hintText = 'Tell us about yourself'
                ' (e.g., write down what you do or what hobbies you have)'
            ..helperText = 'Keep it short, this is just a demo.'
            ..labelText = 'Life story';

          return builder.build();
        }

        FormField<Iterable<String>> get roles {
          final builder = FieldBuilder<Iterable<String>>()
            ..isRequired = true
            ..labelText = 'Roles'
            ..initialValue = EditorRole.values.map((e) => e.toString());

          return builder.build();
        }
      }
    ''');
    final parsedResult = libraryElement.session
        .getParsedLibraryByElement(libraryElement.library);
    print(parsedResult);
  });
}

Future<ClassElement> _createClassElement(final String clazz) async {
  final library = await resolveSource('''
      library test;
      
      import 'package:admin_template_annotation/admin_template_annotation.dart';

      enum EditorRole { moderator, reviewer, composer }

      class Editor {
        final String id;
        final String name;
        final String bio;
        final Iterable<EditorRole> roles;
        final bool isOnline;

        Editor({
          this.id,
          this.name,
          this.bio,
          this.roles,
          this.isOnline,
        });

        Editor copyWith({
          String id,
          String name,
          String bio,
          Iterable<EditorRole> roles,
          bool isOnline,
        }) {
          return Editor(
            id: id ?? this.id,
            name: name ?? this.name,
            bio: bio ?? this.bio,
            roles: roles ?? this.roles,
            isOnline: isOnline ?? this.isOnline,
          );
        }
      }

      class FormField<T> {}

      class FieldBuilder<T> {
        int minLength;
        int maxLength;
        T initialValue;
        bool isRequired;
        String hintText;
        String labelText;
        String helperText;

        FormField<T> build<T>() {
          FormField<T> field = FormField();
          return field;
        }
      }

      class EditForm {
        const EditForm.of(Type modelType);
      }

      abstract class AddForm<ModelType> {}
      
      $clazz
      ''', (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });

  return library.classes.first;
}
