import 'package:admin_template_core/core.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

import 'error.dart';
import 'form_field_input.dart';

class FormClassInput {
  final ClassElement element;

  FormClassInput(this.element);

  ParsedLibraryResult get parsedLibrary => _parsedLibrary ??=
      element.library.session.getParsedLibraryByElement(element.library);

  ClassDeclaration get classDeclaration {
    return _classDeclaration ??=
        parsedLibrary.getElementDeclaration(element).node as ClassDeclaration;
  }

  String get name => element.displayName;

  /// Returns the class name for the generated implementation. If the manually
  /// maintained class is private then we ignore the underscore here, to avoid
  /// returning a class name starting `_$_`.
  String get implName => _implName ??=
      name.startsWith('_') ? '_\$${name.substring(1)}' : '_\$$name';

  String get firstAnnotation => '';

  Iterable<FormFieldInput> get fields =>
      _fields ??= FormFieldInput.fromClassElements(parsedLibrary, element);

  String get source =>
      _source ??= element.library.definingCompilationUnit.source.contents.data;

  String get partStatement {
    var fileName = element.library.source.shortName.replaceAll('.dart', '');
    return "part '$fileName.g.dart';";
  }

  bool get hasPartStatement {
    var expectedCode = partStatement;
    return source.contains(expectedCode);
  }

  /// Find errors if any before running [process]
  Iterable<GeneratorError> computeErrors() {
    return concat([
      _checkFormTemplateClass(),
      _checkFieldList(),
      concat(fields.map((field) => field.computeErrors()))
    ]);
  }

  Iterable<GeneratorError> _checkFormTemplateClass() {
    var result = <GeneratorError>[];

    final className = classDeclaration.name.name;
    if (!className.startsWith('_')) {
      result.add(GeneratorError(
        message: 'Make class $className hidden by'
            'appending underscore (_) prefix.',
        offset: classDeclaration.name.offset - 1,
        length: className.length,
        fix: 'class _$className',
      ));
    }

    return result;
  }

  Iterable<GeneratorError> _checkFieldList() {
    /// FIXME: validate accessors
    return [];
  }

  static bool needsForm(ClassElement classElement) {
    return !classElement.displayName.startsWith('_\$');
  }

  /// backing field of [parsedLibrary]
  ParsedLibraryResult _parsedLibrary;

  /// backing field of [implName]
  String _implName;

  /// backing field of [source]
  String _source;

  /// backing field of [classDeclaration]
  ClassDeclaration _classDeclaration;

  /// backing field of [fields]
  Iterable<FormFieldInput> _fields;
}
