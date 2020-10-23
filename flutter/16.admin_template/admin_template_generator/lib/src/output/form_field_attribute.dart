import 'package:analyzer/dart/ast/ast.dart';

class FormFieldAttribute {
  final String name;
  final Expression expr;

  FormFieldAttribute(this.name, this.expr);
}
