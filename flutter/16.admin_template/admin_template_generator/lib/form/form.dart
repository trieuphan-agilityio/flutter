import 'package:admin_template_core/core.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

import 'base.dart';
import 'field.dart';

const kFlutterWidgets = Reference('Widget', 'flutter:widgets');

class Form with CodeGenMixin implements CodeGen {
  final String name;
  final Iterable<FormField> fields;

  Form(this.name, this.fields);

  @override
  Spec toSpec() {
    return Class((b) => b
      ..name = '_\$$name'
      ..methods = ListBuilder(
        fields
            .map((f) => Method((b) => b
              ..returns = kFlutterWidgets
              ..name = '_build${f.name.toPascalCase()}'
              ..body = Code('return ${f.toSource()};')))
            .toList(),
      ));
  }
}
