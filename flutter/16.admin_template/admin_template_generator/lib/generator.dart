import 'package:admin_template_core/core.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'src/input/error.dart';
import 'src/input/form_class_input.dart';
import 'package:dart_style/dart_style.dart';

import 'src/input/form_settings.dart';
import 'src/output/form.dart';
import 'src/util.dart';

final _dartFormatter = DartFormatter();

class FormGenerator extends GeneratorForAnnotation<AgFormTemplate> {
  const FormGenerator();

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var result = StringBuffer();

    if (element is ClassElement && FormClassInput.needsForm(element)) {
      try {
        // input
        final formInput = FormClassInput(element);
        var errors = formInput.computeErrors();
        if (errors.isNotEmpty) throw _makeError(errors);

        final defaultFormSettings = FormSettings(modelType: null);
        final formSettings = mergeSettings(
          defaultFormSettings,
          annotation,
          classElement: element,
        );

        // process
        final output = Form(
          formInput.implName,
          formSettings.modelType,
          formInput.fields.map((f) => f.toFormField()),
        );

        // output
        result.writeln(_dartFormatter.format(
          output.toSpec().accept(DartEmitter.scoped()).toString(),
        ));
      } catch (e, st) {
        result.writeln(_error(e));
        log.severe('Error in FormGenerator for $element.', e, st);
      }
    }

    return result.toString();
  }
}

String _error(Object error) {
  var lines = '$error'.split('\n');
  var indented = lines.skip(1).map((l) => '//        $l'.trim()).join('\n');
  return '// Error: ${lines.first}\n$indented';
}

InvalidGenerationSourceError _makeError(Iterable<GeneratorError> todos) {
  var message =
      StringBuffer('Please make the following changes to use Form Codegen:\n');
  for (var i = 0; i != todos.length; ++i) {
    message.write('\n${i + 1}. ${todos.elementAt(i).message}');
  }

  return InvalidGenerationSourceError(message.toString());
}
