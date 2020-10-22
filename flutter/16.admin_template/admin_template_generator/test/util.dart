import 'dart:io';

import 'package:admin_template_core/core.dart';
import 'package:admin_template_generator/generator.dart';
import 'package:admin_template_generator/src/input/form_field_input.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

/// [filePaths] Paths to files that are relative to test_resource folder.
///   It would be used to read the input of test as string format.
///   The result is the list of content read from [filePaths].
Iterable<String> loadFiles(Iterable<String> filePaths) sync* {
  for (final filePath in filePaths) {
    final file = new File('test_resource/$filePath');
    yield file.readAsStringSync();
  }
}

final _dartfmt = DartFormatter();

String _format(final String source) {
  try {
    return _dartfmt.format(source);
  } on FormatException catch (_) {
    return _dartfmt.formatStatement(source);
  }
}

/// Should be invoked in `main()` of every test in `test/**_test.dart`.
void useDartfmt() => EqualsDart.format = _format;

// Supports codegen

final String pkgName = 'pkg';

final Builder builder = PartBuilder([const FormGenerator()], '.g.dart');

Future<String> generate(String source) async {
  var srcs = <String, String>{
    'test_support|lib/test_support.dart': testSupportSource,
    '$pkgName|lib/form.dart': source,
  };

  // Capture any error from generation; if there is one, return that instead of
  // the generated output.
  String error;
  void captureError(LogRecord logRecord) {
    if (logRecord.error is InvalidGenerationSourceError) {
      if (error != null) throw StateError('Expected at most one error.');
      error = logRecord.error.toString();
    }
  }

  var writer = InMemoryAssetWriter();
  await testBuilder(builder, srcs,
      rootPackage: pkgName, writer: writer, onLog: captureError);

  return error ??
      String.fromCharCodes(
        writer.assets[AssetId(pkgName, 'lib/form.g.dart')] ?? [],
      );
}

// Classes mentioned in the test input need to exist, but we don't need the
// real versions. So just use minimal ones.
const String testSupportSource = r'''
class Key {}

class AgFieldTemplate<T> {}

class AgTextTemplate {}

class AddForm {}
''';

/// Form Field Utilities -------------------------------------------------------

Future<FormFieldInput> makeFormFieldInput(String field) async {
  final fieldElement = await _makeFieldElement(field);
  final parsedLibrary = fieldElement.session.getParsedLibraryByElement(
    fieldElement.library,
  );
  return FormFieldInput(parsedLibrary, fieldElement);
}

Future<FieldElement> _makeFieldElement(String field) async {
  final library = await resolveSource("""
    library test;
    
    import 'package:admin_template_core/core.dart';
    
    class Foo {
      $field
    }
    """, (resolver) async {
    return LibraryReader(await resolver.findLibraryByName('test'));
  });
  return library.classes.first.fields.first;
}
