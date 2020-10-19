import 'package:code_builder/code_builder.dart';
import 'package:analyzer/dart/ast/ast.dart' as ast;
import 'package:dart_style/dart_style.dart';

final _dartFormatter = DartFormatter();

abstract class CodeGen {
  Spec toSpec();
  String toSource();
}

mixin CodeGenMixin {
  Spec toSpec() {
    throw 'Missing implementation for method `toSpec()`';
  }

  /// Generate code using Spec from CodeBuilder
  String toSource() {
    return _dartFormatter
        .format(toSpec().accept(DartEmitter.scoped()).toString());
  }
}

extension NamedArguments on Map<String, ast.Expression> {
  Map<String, Expression> toNamedArguments() {
    return this.map((fieldName, fieldExpr) {
      return MapEntry(fieldName, fieldExpr.toCodeBuilderExpression());
    });
  }
}

extension ToCodeBuilderExpression on ast.Expression {
  Expression toCodeBuilderExpression() {
    if (this is ast.StringLiteral) {
      return literalString((this as ast.StringLiteral).stringValue);
    }

    if (this is ast.BooleanLiteral) {
      return literalBool((this as ast.BooleanLiteral).value);
    }

    throw 'Value of form field []';
  }
}
