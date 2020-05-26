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
      ..fields.add(_createModelField())
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

  Field _createModelField() {
    return Field((b) => b
      ..name = 'model'
      ..type = refer(form.model.name));
  }

  Method _createBuilderMethod() {
    String formFields = form.model.fields
        .map((f) => '${f.name},')
        .join('const SizedBox(height: 24),');

    return Method((b) => b
      ..annotations.add(refer('override'))
      ..name = 'builder'
      ..type = MethodType.getter
      ..returns = refer('FormBuilder')
      ..body = Code.scope((allocate) {
        return '''
          return (
            BuildContext context, {
            bool autovalidate = false,
            WillPopCallback onWillPop,
            VoidCallback onChanged,
            ValueChanged<User> onSaved,
          }) {
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
                    autovalidate: autovalidate,
                    onWillPop: onWillPop,
                    onChanged: onChanged,
                    child: Builder(
                      builder: (BuildContext fContext) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              $formFields
                              const SizedBox(height: 24),
                              Row(children: [
                                RaisedButton(
                                  color: Theme.of(context).buttonColor,
                                  child: Text('Save'),
                                  onPressed: () {
                                    final formState = Form.of(fContext);
                                    if (formState.validate()) {
                                      Form.of(fContext).save();
                                      onSaved(model);
                                    }
                                  },
                                ),
                                RaisedButton(
                                  child: Text('Reset'),
                                  onPressed: () {
                                    Form.of(fContext).reset();
                                  },
                                ),
                                RaisedButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    print('Cancel');
                                  },
                                ),
                              ]),
                            ],
                          ),
                        );
                      },
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
        .map((field) => FieldWriter(form.model, field).write())
        .toList();
  }
}
