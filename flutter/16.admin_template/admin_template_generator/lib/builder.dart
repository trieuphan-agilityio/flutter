import 'package:admin_template_generator/generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// This triggers the code generation process.
///
/// Use 'flutter packages pub run build_runner build' to start code generation.
///
/// Use 'flutter packages pub run build_runner watch' to trigger
/// code generation on changes.
Builder formBuilder(final BuilderOptions _) =>
    SharedPartBuilder([FormGenerator()], 'admin_template');
