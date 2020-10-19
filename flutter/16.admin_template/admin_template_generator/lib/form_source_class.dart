import 'package:admin_template_core/core.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'error.dart';
import 'form/form.dart';
import 'form_source_field.dart';

class FormSourceClass {
  final ClassElement element;

  FormSourceClass(this.element);

  ParsedLibraryResult get parsedLibrary => _parsedLibrary ??=
      element.library.session.getParsedLibraryByElement(element.library);

  String get name => element.displayName;

  /// Returns the class name for the generated implementation. If the manually
  /// maintained class is private then we ignore the underscore here, to avoid
  /// returning a class name starting `_$_`.
  String get implName => _implName ??=
      name.startsWith('_') ? '_\$${name.substring(1)}' : '_\$$name';

  String get partStatement {
    var fileName = element.library.source.shortName.replaceAll('.dart', '');
    return "part '$fileName.g.dart';";
  }

  Iterable<FormSourceField> get fields =>
      _fields ??= FormSourceField.fromClassElements(parsedLibrary, element);

  String get source =>
      _source ??= element.library.definingCompilationUnit.source.contents.data;

  bool get hasPartStatement {
    var expectedCode = partStatement;
    return source.contains(expectedCode);
  }

  ClassDeclaration get classDeclaration {
    return _classDeclaration ??=
        parsedLibrary.getElementDeclaration(element).node as ClassDeclaration;
  }

  String generateCode() {
    var errors = computeErrors();
    if (errors.isNotEmpty) throw _makeError(errors);

    final form = Form(implName, fields.map((f) => f.toFormField()));
    return form.toSource();
  }

  Iterable<GeneratorError> computeErrors() {
    return concat([
      _checkPart(),
      _checkFormClass(),
      _checkFieldList(),
      concat(fields.map((field) => field.computeErrors()))
    ]);
  }

  Iterable<GeneratorError> _checkPart() {
    if (hasPartStatement) return [];

    var directives = (classDeclaration.parent as CompilationUnit).directives;
    if (directives.isEmpty) {
      return [
        GeneratorError(
          message: 'Import generated part: $partStatement',
          offset: 0,
          length: 0,
          fix: '$partStatement\n\n',
        ),
      ];
    } else {
      return [
        GeneratorError(
          message: 'Import generated part: $partStatement',
          offset: directives.last.offset + directives.last.length,
          length: 0,
          fix: '\n\n$partStatement\n\n',
        ),
      ];
    }
  }

  Iterable<GeneratorError> _checkFormClass() {
    var result = <GeneratorError>[];

    var implementsClause = classDeclaration.implementsClause;

    var implementsClauseIsCorrect =
        implementsClause != null && implementsClause.interfaces.length == 1;

    if (!implementsClauseIsCorrect) {
      result.add(GeneratorError(
        message: 'Make class implements AddForm<T>.'
            ' The inteface should use for code generation only.',
        offset: classDeclaration.leftBracket.offset - 1,
        length: 0,
        fix: 'implements AddForm<T>',
      ));
    }

    // FIXME: raise error if use "extends" by mistake

    return result;
  }

  Iterable<GeneratorError> _checkFieldList() {
    /// FIXME: validate accessors
    return [];
  }

  static bool needsForm(ClassElement classElement) {
    return !classElement.displayName.startsWith('_\$') &&
        (classElement.allSupertypes.any(
          (interfaceType) => interfaceType.element.name.startsWith('AddForm'),
        ));
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
  Iterable<FormSourceField> _fields;
}

InvalidGenerationSourceError _makeError(Iterable<GeneratorError> todos) {
  var message =
      StringBuffer('Please make the following changes to use Form Codegen:\n');
  for (var i = 0; i != todos.length; ++i) {
    message.write('\n${i + 1}. ${todos.elementAt(i).message}');
  }

  return InvalidGenerationSourceError(message.toString());
}
