import 'package:admin_template_generator/value_object/form.dart';
import 'package:admin_template_generator/writer/field_writer.dart';
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
      ..methods.addAll([
        _createBuilderMethod(),
        ..._createGetters(),
      ]);

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
        ..type = refer(form.model.name)
        ..modifier = FieldModifier.final$)
    ];
  }

  Method _createBuilderMethod() {
    String formFields = form.model.fields
        .map((f) => '${f.name},')
        .join('const SizedBox(height: 24),');

    return Method((b) => b
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
                          $formFields
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          };
          ''';
      }));
  }

  List<Spec> _createGetters() {
    return form.model.fields
        .map((f) => FieldWriter(f, form.model).write())
        .toList();
  }
}
