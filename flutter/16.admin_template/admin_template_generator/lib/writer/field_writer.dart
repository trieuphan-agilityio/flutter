import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:admin_template_generator/writer/field_attribute_writer.dart';
import 'package:admin_template_generator/writer/writer.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';
import 'package:meta/meta.dart';

/// Creates the implementation of a Form field
abstract class FieldWriter extends Writer {
  /// Keep a reference to the origin model
  final Model model;
  final ModelField field;

  FieldWriter._(this.model, this.field);

  factory FieldWriter(Model model, ModelField field) {
    final fieldType = field.formFieldAnnotation.type.getDisplayString();
    switch (fieldType) {
      case Annotation.agText:
      case Annotation.agEmail:
        return TextFieldWriter(model, field);
      case Annotation.agBool:
        return BoolFieldWriter(model, field);
      case Annotation.agPassword:
        return PasswordFieldWriter(model, field);
      case Annotation.agList:
        return TextFieldWriter(model, field);
      default:
        throw ArgumentError('$fieldType is not supported');
    }
  }

  Spec writeAttributes() {
    String attributes = '';

    for (var attr in field.attributes) {
      switch (attr.name) {
        case FieldAnnotation.labelText:
        case FieldAnnotation.hintText:
        case FieldAnnotation.helperText:
          attributes +=
              StringFieldAttributeWriter(model, field, attr).write().toString();
          break;

        case FieldAnnotation.initialValue:
        case FieldAnnotation.maxLength:
        case FieldAnnotation.validator:
          attributes +=
              PlainFieldAttributeWriter(model, field, attr).write().toString();
          break;
        case FieldAnnotation.choices:
          attributes +=
              PlainFieldAttributeWriter(model, field, attr).write().toString();
          break;

        default:
          break;
      }
    }
    return Code(attributes);
  }
}

typedef WriteBody = Spec Function();

class BaseFieldWriter extends FieldWriter {
  final WriteBody writeBody;

  BaseFieldWriter(Model model, ModelField field, {@required this.writeBody})
      : super._(model, field);

  @override
  Spec write() {
    final fieldBuilder = Method((b) => b
      ..name = field.name
      ..type = MethodType.getter
      ..returns = refer('Widget')
      ..body = writeBody()).toBuilder();
    return fieldBuilder.build();
  }
}

/// ===================================================================
/// AgTextField
/// ===================================================================

class TextFieldWriter extends FieldWriter {
  FieldWriter delegate;

  TextFieldWriter(Model model, ModelField field) : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        return AgTextField(
          ${writeAttributes()}
        );
        ''',
      );
    });
  }

  @override
  Spec write() {
    return delegate.write();
  }
}

/// ===================================================================
/// AgCheckboxField
/// ===================================================================

class BoolFieldWriter extends FieldWriter {
  FieldWriter delegate;

  BoolFieldWriter(Model model, ModelField field) : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        return AgCheckboxField(
          ${writeAttributes()}
        );
        ''',
      );
    });
  }

  @override
  Spec write() {
    return delegate.write();
  }
}

/// ===================================================================
/// AgPasswordField
/// ===================================================================

class PasswordFieldWriter extends FieldWriter {
  FieldWriter delegate;

  PasswordFieldWriter(Model model, ModelField field) : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        return AgPasswordField(
          ${writeAttributes()}
        );
        ''',
      );
    });
  }

  @override
  Spec write() {
    return delegate.write();
  }
}

/// ===================================================================
/// AgCheckboxListField
/// ===================================================================

class CheckboxListFieldWriter extends FieldWriter {
  FieldWriter delegate;

  CheckboxListFieldWriter(Model model, ModelField field)
      : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        AgCheckboxListField(
          ${writeAttributes()}
        );
        ''',
      );
    });
  }

  @override
  Spec write() {
    return delegate.write();
  }
}
