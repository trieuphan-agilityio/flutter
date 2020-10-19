import 'package:admin_template_core/core.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

import 'field.dart';

const kFlutterWidgets = Reference('Widget', 'flutter:widgets');
const kFlutterStatefulWidget = Reference('StatefulWidget', 'flutter:widgets');

class Form {
  final String name;
  final Iterable<FormField> fields;

  Form(this.name, this.fields);

  Spec toSpec() {
    return Class((b) => b
      ..name = name
      ..extend = kFlutterStatefulWidget
      ..methods = ListBuilder(
        fields
            .map((f) => Method((b) => b
              ..returns = kFlutterWidgets
              ..name = '_build${f.name.toPascalCase()}'
              ..body = f.toExpression().returned.statement))
            .toList(),
      ));
  }
}
