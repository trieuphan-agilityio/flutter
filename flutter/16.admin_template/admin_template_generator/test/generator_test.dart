import 'package:admin_template_generator/generator.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    '_form_generator_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    const FormGenerator(),
    expectedAnnotatedTests: _expectedAnnotatedTests,
  );
}

const _expectedAnnotatedTests = [
  '_LoginForm',
];
