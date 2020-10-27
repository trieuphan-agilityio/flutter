import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
// ignore: implementation_imports
import 'package:admin_template_generator/src/input/form_class_input.dart';

/// Checks a library for errors related to built_value generation. Returns
/// the errors and, where possible, corresponding fixes.
class Checker {
  Map<AnalysisError, PrioritizedSourceChange> check(
      LibraryElement libraryElement) {
    var result = <AnalysisError, PrioritizedSourceChange>{};

    for (var compilationUnit in libraryElement.units) {
      // Don't analyze if there's no source; there's nothing to do.
      if (compilationUnit.source == null) continue;
      // Don't analyze generated source; there's nothing to do.
      if (compilationUnit.source.fullName.endsWith('.g.dart')) continue;

      for (var type in compilationUnit.types) {
        if (!FormClassInput.needsForm(type)) {
          continue;
        }

        final sourceClass = FormClassInput(type);
        final errors = sourceClass.computeErrors();

        if (errors.isNotEmpty) {
          final lineInfo = compilationUnit.lineInfo;

          // Report one error on the AgFormTemplate class. Bundle together all
          // the necessary fixes.

          // TODO: split error message and example; only show
          // example in the build error, not in the IDE.
          final formTemplateNode = sourceClass.classDeclaration;
          final offset = formTemplateNode.offset;
          final length = formTemplateNode.length;
          final offsetLineLocation = lineInfo.getLocation(offset);
          final error = AnalysisError(
              AnalysisErrorSeverity.ERROR,
              AnalysisErrorType.LINT,
              Location(
                  compilationUnit.source.fullName,
                  offset,
                  length,
                  offsetLineLocation.lineNumber,
                  offsetLineLocation.columnNumber),
              'Class needs fixes for admin_template: ' +
                  errors.map((error) => error.message).join(' '),
              'ADMIN_TEMPLATE_NEEDS_FIXES');

          // Fix consists of all the individual fixes, sorted so they apply
          // from the end of the file backwards, so each fix does not
          // invalidate the line numbers for the following fixes.
          final edits = errors
              .where((error) => error.fix != null)
              .map((error) => SourceEdit(error.offset, error.length, error.fix))
              .toList();
          edits.sort((left, right) => right.offset.compareTo(left.offset));

          final fix = PrioritizedSourceChange(
              1000000,
              SourceChange(
                'Apply fixes for admin_template.',
                edits: [
                  SourceFileEdit(
                    compilationUnit.source.fullName,
                    compilationUnit.source.modificationStamp,
                    edits: edits,
                  )
                ],
              ));
          result[error] = fix;
        }
      }
    }

    return result;
  }
}
