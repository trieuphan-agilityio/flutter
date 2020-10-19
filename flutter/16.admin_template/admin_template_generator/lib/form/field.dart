import 'package:analyzer/dart/ast/ast.dart' as ast;
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';

import 'base.dart';

enum FieldType {
  text,
  int,
  date,
  bool,
  listBool,
}

abstract class FormField {
  String get name;
  Expression toExpression();

  factory FormField.text(String name, Map<String, ast.Expression> attrs) {
    return TextField(name, attrs);
  }

  static const initialValue = 'initialValue';
  static const isRequired = 'isRequired';
  static const labelText = 'labelText';
  static const hintText = 'hintText';
  static const onSaved = 'onSaved';
  static const maxLength = 'maxLength';
  static const minLength = 'minLength';
  static const min = 'min';
  static const max = 'max';
}

class TextField implements FormField {
  final String name;
  final Map<String, ast.Expression> attrs;

  const TextField(this.name, this.attrs);

  Expression toExpression() {
    return _kAgTextField.call(
      [],
      attrs.toNamedArguments()
        ..putIfAbsent(FormField.initialValue, () => makeInitialValue(name))
        ..putIfAbsent(FormField.onSaved, () => makeOnSaved(name)),
    );
  }

  static const _kAgTextField =
      Reference('AgTextField', 'admin_template:admin_template');
}

Spec makeInitialValue(String propertyName) {
  return refer('model').property(propertyName);
}

Spec makeOnSaved(String propertyName) {
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
