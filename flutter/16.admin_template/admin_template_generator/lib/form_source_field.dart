import 'package:admin_template_generator/form/field.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import 'dart_types.dart';
import 'error.dart';
import 'field.dart';

class FormSourceField {
  /// Suffix of name of getter that indicates that the getter should be used
  /// as form field template.
  static const kGetterSuffix = 'Template';

  final ParsedLibraryResult parsedLibrary;
  final FieldElement element;

  FormSourceField(this.parsedLibrary, this.element);

  MethodDeclaration get astNode =>
      _astNode ??= parsedLibrary.getElementDeclaration(element.getter).node
          as MethodDeclaration;

  /// Name of the form field.
  ///
  /// e.g: given field declation
  /// ```
  /// AgTextField get firstNameTemplate
  /// ```
  ///
  /// the result is
  /// ```
  /// firstName
  /// ```
  String get name => element.displayName
      .substring(0, element.displayName.length - kGetterSuffix.length);

  String get type => DartTypes.getName(element.getter.returnType);

  bool get isFunctionType => type.contains('(');

  /// The [type] plus any import prefix.
  String get typeWithPrefix {
    var typeFromAst = astNode?.returnType?.toSource() ?? 'dynamic';
    var typeFromElement = type;

    // If the type is a function, we can't use the element result; it is
    // formatted incorrectly.
    if (isFunctionType) return typeFromAst;

    // If the type does not have an import prefix, prefer the element result.
    // It handles inherited generics correctly.
    if (!typeFromAst.contains('.')) return typeFromElement;

    return typeFromAst;
  }

  /// Returns the type with import prefix if the compilation unit matches,
  /// otherwise the type with no import prefix.
  String typeInCompilationUnit(CompilationUnitElement compilationUnitElement) {
    return compilationUnitElement == element.library.definingCompilationUnit
        ? typeWithPrefix
        : type;
  }

  bool get isGetter => element.getter != null && !element.getter.isSynthetic;

  FormField toFormField() {
    final fieldVisitor = _GetFieldAttributes();
    astNode.visitChildren(fieldVisitor);
    return FormField.text(name, fieldVisitor.attrs);
  }

  Iterable<GeneratorError> computeErrors() {
    var result = <GeneratorError>[];

    if (!isGetter) {
      result.add(GeneratorError(message: 'Make field $name a getter.'));
    }

    if (type == 'dynamic') {
      result.add(GeneratorError(
        message: 'Make field $name have non-dynamic type. '
            'If you are already specifying a type, '
            'please make sure the type is correctly imported.',
      ));
    }

    if (name.startsWith('_')) {
      result.add(GeneratorError(
        message: 'Make field $name public; remove the underscore.',
      ));
    }

    return result;
  }

  static Iterable<FormSourceField> fromClassElements(
      ParsedLibraryResult parsedLibrary, ClassElement classElement) {
    var result = <FormSourceField>[];

    for (var field in collectFields(classElement)) {
      if (field.displayName.endsWith(kGetterSuffix) &&
          !field.isStatic &&
          field.getter != null) {
        result.add(FormSourceField(parsedLibrary, field));
      }
    }

    return result;
  }

  /// backing field of [astNode]
  MethodDeclaration _astNode;
}

/// Visitor that handles Cascade Expression
class _GetFieldAttributes extends RecursiveAstVisitor {
  final Map<String, Expression> attrs = {};

  @override
  void visitCascadeExpression(CascadeExpression node) {
    for (final expr in node.cascadeSections) {
      final assignmentExpr = expr as AssignmentExpression;
      final fieldProperty =
          (assignmentExpr.leftHandSide as PropertyAccess).propertyName.name;
      final fieldValueExpr = assignmentExpr.rightHandSide;
      attrs.putIfAbsent(fieldProperty, () => fieldValueExpr);
    }
    return null;
  }
}
