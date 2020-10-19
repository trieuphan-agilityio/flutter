import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart' hide Expression;
import 'package:code_builder/src/base.dart';

import 'base.dart';

enum FieldType {
  text,
  int,
  date,
  bool,
  listBool,
}

abstract class FormField implements CodeGen {
  String get name;

  factory FormField.text(String name, Map<String, Expression> attrs) {
    return TextField(name, attrs);
  }

  static const initialValue = 'initialValue';
  static const isRequired = 'isRequired';
  static const labelText = 'labelText';
  static const hintText = 'hintText';
  static const onSave = 'onSave';
}

class TextField with CodeGenMixin implements FormField {
  final String name;
  final Map<String, Expression> attrs;

  const TextField(this.name, this.attrs);

  @override
  Spec toSpec() {
    return _kAgTextField.call(
      [],
      attrs.toNamedArguments()
        ..putIfAbsent(FormField.onSave, () => makeOnSave(name))
        ..putIfAbsent(FormField.initialValue, () => makeInitialValue(name)),
    );
  }

  static const _kAgTextField =
      Reference('AgTextField', 'admin_template:admin_template');
}

Spec makeInitialValue(String propertyName) {
  return refer('model').property(propertyName);
}

Spec makeOnSave(String propertyName) {
  return Method(
    (b) => b
      ..requiredParameters.add(Parameter((b) => b..name = 'newValue'))
      ..body = refer('model')
          .assign(refer('model').property('copyWith').call(
            [],
            {propertyName: refer('newValue')},
          ))
          .statement,
  ).closure;
}
