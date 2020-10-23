import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

import 'form_field.dart';
import 'form_field_attribute.dart';

const _kAgListTemplate = 'AgListTemplate';
const _kAgBoolTemplate = 'AgBoolTemplate';
const _kAgSecureTemplate = 'AgSecureTemplate';

class FormFieldFactory {
  factory FormFieldFactory() {
    if (shared == null) shared = FormFieldFactory._();
    return shared;
  }
  const FormFieldFactory._();
  static FormFieldFactory shared;

  FormField createFormField(
    String name,
    Iterable<FormFieldAttribute> attrs, {
    @required String templateName,
    @required ParameterizedType typeArgument,
    @required String typeArgumentName,
  }) {
    if (typeArgument != null && typeArgument.isDartCoreBool) {
      return CheckboxField(name, attrs);
    }

    if (templateName == _kAgBoolTemplate) {
      return CheckboxField(name, attrs);
    }

    if (templateName.startsWith(_kAgListTemplate) && typeArgumentName != null) {
      return CheckboxListField(name, attrs, refer(typeArgumentName));
    }

    if (templateName == _kAgSecureTemplate) {
      return SecureField(name, attrs);
    }

    return TextField(name, attrs);
  }
}
