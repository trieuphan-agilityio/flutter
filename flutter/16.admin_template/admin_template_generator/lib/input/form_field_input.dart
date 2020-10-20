import 'dart:collection';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_collection/built_collection.dart';

import '../output/form_field.dart';
import 'dart_types.dart';
import 'error.dart';

class FormFieldInput {
  /// Suffix of name of getter that indicates that the getter should be used
  /// as form field template.
  static const kGetterSuffix = 'Template';

  final ParsedLibraryResult parsedLibrary;
  final FieldElement element;

  FormFieldInput(this.parsedLibrary, this.element);

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

  static Iterable<FormFieldInput> fromClassElements(
      ParsedLibraryResult parsedLibrary, ClassElement classElement) {
    var result = <FormFieldInput>[];

    for (var field in collectFields(classElement)) {
      if (field.displayName.endsWith(kGetterSuffix) &&
          !field.isStatic &&
          field.getter != null) {
        result.add(FormFieldInput(parsedLibrary, field));
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

/// Gets fields, including from interfaces. Fields from interfaces are only
/// returned if they are not also implemented by a mixin.
///
/// If a field is overridden then just the closest (overriding) field is
/// returned.
Iterable<FieldElement> collectFields(ClassElement element) =>
    collectFieldsForType(element.thisType);

/// Gets fields, including from interfaces. Fields from interfaces are only
/// returned if they are not also implemented by a mixin.
///
/// If a field is overridden then just the closest (overriding) field is
/// returned.
Iterable<FieldElement> collectFieldsForType(InterfaceType type) {
  var fields = <FieldElement>[];
  // Add fields from this class before interfaces, so they're added to the set
  // first below. Re-added fields from interfaces are ignored.
  fields.addAll(_fieldElementsForType(type));

  Set<InterfaceType>.from(type.interfaces)
    ..addAll(type.mixins)
    ..forEach((interface) => fields.addAll(collectFieldsForType(interface)));

  // Overridden fields have multiple declarations, so deduplicate by adding
  // to a set that compares on field name.
  var fieldSet = LinkedHashSet<FieldElement>(
      equals: (a, b) => a.displayName == b.displayName,
      hashCode: (a) => a.displayName.hashCode);
  fieldSet.addAll(fields);

  // Filter to fields that are not implemented by a mixin.
  return BuiltList<FieldElement>.build((b) => b
    ..addAll(fieldSet)
    ..where((field) =>
        type
            .lookUpGetter2(
              field.name,
              field.library,
              inherited: true,
              concrete: true,
            )
            ?.isAbstract ??
        true));
}

BuiltList<FieldElement> _fieldElementsForType(InterfaceType type) {
  var result = ListBuilder<FieldElement>();
  for (var accessor in type.accessors) {
    if (accessor.isSetter) continue;
    result.add(accessor.variable as FieldElement);
  }
  return result.build();
}
