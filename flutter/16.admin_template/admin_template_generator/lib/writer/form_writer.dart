import 'package:admin_template_generator/writer/writer.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';

class FormField {
  final PropertyAccessorElement fieldElement;
  final String name;
  final DartType rawType;

  FormField(this.fieldElement, this.name, this.rawType);
}

class Form {
  final ClassElement classElement;
  final String name;
  final List<FormField> fields;

  Form(this.classElement, this.name, this.fields);
}

/// Creates the implementation of a Form
class FormWriter extends Writer {
  final Form form;

  FormWriter(this.form);

  @override
  Spec write() {
    final classBuilder = ClassBuilder()
      ..name = '_\$Edit${form.name}'
      ..extend = refer('UserForm')
      ..constructors.add(_createConstructor())
      ..fields.addAll(_createFields())
      ..methods.addAll(_createGetters());

    return classBuilder.build();
  }

  Constructor _createConstructor() {
    return Constructor((b) => b
      ..requiredParameters.add(Parameter((pb) => pb..name = 'this.model'))
      ..annotations);
  }

  List<Field> _createFields() {
    return [
      Field((b) => b
        ..name = 'model'
        ..type = refer('User')
        ..modifier = FieldModifier.final$)
    ];
  }

  List<Method> _createGetters() {
    return [
      Method((b) => b
        ..annotations.add(refer('override'))
        ..name = 'builder'
        ..type = MethodType.getter
        ..body = Code.scope((allocate) {
          return '''
          return (BuildContext context) {
            return Container(
              alignment: Alignment.topLeft,
              width: 800,
              child: Shortcuts(
                shortcuts: <LogicalKeySet, Intent>{
                  // Pressing enter on the field will now move to the next field.
                  LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
                },
                child: FocusTraversalGroup(
                  child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          username,
                          const SizedBox(height: 24),
                          email,
                          const SizedBox(height: 24),
                          phone,
                          const SizedBox(height: 24),
                          bio,
                          const SizedBox(height: 24),
                          password,
                          const SizedBox(height: 24),
                          passwordConfirmation,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          };
          ''';
        })),
      ...form.fields.map((f) {
        final getter = Method((b) => b
          ..annotations.add(refer('override'))
          ..name = f.name
          ..type = MethodType.getter
          ..returns = refer('FormField<String>')
          ..body = Code.scope((allocate) {
            return '''
            return AgTextField(
              labelText: '${f.name}',
              onSaved: (newValue) {
                model.rebuild((b) => b.${f.name} = newValue);
              },
              validator: (value) {
                final validator = NameValidator<User>(propertyResolver: (user) {
                  return user.${f.name};
                });
                return validator.validate(model);
              },
            );
          ''';
          }));
        return getter;
      }).toList(),
    ];
  }
}
