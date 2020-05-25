import 'package:admin_template_generator/value_object/model.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:admin_template_generator/writer/writer.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';

class BoolFieldAttributeWriter implements Writer {
  final Model model;
  final ModelField field;
  final FieldAttribute<bool> attribute;

  BoolFieldAttributeWriter(this.model, this.field, this.attribute);

  @override
  Spec write() {
    return Code('${attribute.name}: ${attribute.value},');
  }
}

class StringFieldAttributeWriter implements Writer {
  final Model model;
  final ModelField field;
  final FieldAttribute<String> attribute;

  StringFieldAttributeWriter(this.model, this.field, this.attribute);

  @override
  Spec write() {
    return Code('${attribute.name}: \"${attribute.value}\",');
  }
}
