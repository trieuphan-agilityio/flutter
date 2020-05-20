import 'package:admin_template_generator/value_object/form.dart';
import 'package:admin_template_generator/writer/writer.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';

/// Creates the implementation of a Form
class FormWriter extends Writer {
  final Form form;

  FormWriter(this.form);

  @override
  Spec write() {
    final classBuilder = ClassBuilder()
      ..name = '_\$${form.name}'
      ..extend = refer(form.name)
      ..constructors.add(_createConstructor())
      ..fields.addAll(_createFields())
      ..methods.addAll(_createGetters());

    return classBuilder.build();
  }

  Constructor _createConstructor() {
    return Constructor((b) => b
      ..requiredParameters.add(Parameter((pb) => pb..name = 'this.model'))
      ..initializers.add(Code('super._()')));
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
        ..returns = refer('Widget Function(BuildContext)')
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
      ...form.model.fields.map((f) {
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
