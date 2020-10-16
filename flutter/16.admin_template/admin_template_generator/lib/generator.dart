import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'form_source_class.dart';

class FormGenerator extends Generator {
  const FormGenerator();

  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var result = StringBuffer();

    // find ast node of form class template that implements AddForm<T>
    for (var element in library.allElements) {
      if (element is ClassElement && FormSourceClass.needsForm(element)) {
        try {
          result.writeln(FormSourceClass(element).generateCode() ?? '');
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
