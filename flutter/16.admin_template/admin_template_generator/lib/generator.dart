import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'input/error.dart';
import 'input/form_class_input.dart';
import 'package:dart_style/dart_style.dart';

import 'output/form.dart';

final _dartFormatter = DartFormatter();

class FormGenerator extends Generator {
  const FormGenerator();

  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var result = StringBuffer();

    // find ast node of form class template that implements AddForm<T>
    for (var element in library.allElements) {
      if (element is ClassElement && FormClassInput.needsForm(element)) {
        try {
          // input
          final formInput = FormClassInput(element);
          var errors = formInput.computeErrors();
          if (errors.isNotEmpty) throw _makeError(errors);

          // process
          final output = Form(
            formInput.implName,
            'LoginModel',
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
