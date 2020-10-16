import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

import 'dart_types.dart';
import 'error.dart';
import 'field.dart';

class FormSourceField {
  final ParsedLibraryResult parsedLibrary;
  final FieldElement element;

  FormSourceField(this.parsedLibrary, this.element);

  String get name => element.displayName;

  String get type => DartTypes.getName(element.getter.returnType);

  bool get isFunctionType => type.contains('(');

  /// The [type] plus any import prefix.
  String get typeWithPrefix {
    var typeFromAst = (parsedLibrary.getElementDeclaration(element.getter).node
                as MethodDeclaration)
            ?.returnType
            ?.toSource() ??
        'dynamic';
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
      if (!field.isStatic &&
          field.getter != null &&
          (field.getter.isAbstract || field.getter.isSynthetic)) {
        result.add(FormSourceField(parsedLibrary, field));
      }
    }

    return result;
  }
}
