import 'package:code_builder/code_builder.dart';
import 'package:analyzer/dart/ast/ast.dart' as ast;

extension NamedArguments on Map<String, ast.Expression> {
  Map<String, Expression> toNamedArguments() {
    return this.map((fieldName, astExpr) {
      return MapEntry(fieldName, CodeExpression(Code(astExpr.toSource())));
    });
  }
}
