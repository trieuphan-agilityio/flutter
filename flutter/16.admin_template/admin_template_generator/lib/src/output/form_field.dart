import 'package:analyzer/dart/ast/ast.dart' as ast;
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';

import 'base.dart';

enum FieldType { text, int, date, bool, listBool }

abstract class FormField {
  String get name;
  Expression toWidgetExpression();

  const FormField();

  factory FormField.text(String name, Map<String, ast.Expression> attrs) {
    return TextField(name, attrs);
  }

  Expression handleInitialValueAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleIsRequiredAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleLabelTextAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleHintTextAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleOnSavedAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleMaxLengthAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleMinLengthAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleMinAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Expression handleMaxAttribute(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

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

const kAgTextField = Reference('AgTextField');

class TextField extends FormField {
  final String name;
  final Map<String, ast.Expression> attrs;

  const TextField(this.name, this.attrs);

  @override
  Expression handleIsRequiredAttribute(ast.Expression astExpr) {
    return super.handleIsRequiredAttribute(astExpr);
  }

  Expression toWidgetExpression() {
    return kAgTextField.call(
      [],
      attrs.toNamedArguments()
        ..putIfAbsent(FormField.initialValue, () => makeInitialValue(name))
        ..putIfAbsent(FormField.onSaved, () => makeOnSaved(name)),
    );
  }
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
