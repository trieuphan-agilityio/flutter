import 'package:code_builder/code_builder.dart';
import 'package:analyzer/dart/ast/ast.dart' as ast;

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

    if (this is ast.IntegerLiteral) {
      return literalNum((this as ast.IntegerLiteral).value);
    }

    throw 'Value of form field []';
  }
}
