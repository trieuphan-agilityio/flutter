import 'dart:io';

import 'package:admin_template_core/core.dart';
import 'package:admin_template_generator/generator.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

/// [inputPath] Path to file relative to test_resource folder.
///   It would be used to read the input of test as string format.
///
/// [expectedPath] Path to file relative to test_resource folder.
///   It would be used as the expectation of the test.
///
Future<void> runAndExpect(
  String inputPath,
  String expectedPath,
  dynamic Function(String, String) body, {
  String testOn,
  Timeout timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic> onPlatform,
  int retry,
}) async {
  final inputFile = new File('test_resource/$inputPath');
  final input = await inputFile.readAsString();

  final expectedFile = new File('test_resource/$expectedPath');
  final expected = await expectedFile.readAsString();

  await body(input, expected);
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
