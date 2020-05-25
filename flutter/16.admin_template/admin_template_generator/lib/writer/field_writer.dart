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
    switch (field.formFieldAnnotation.type.getDisplayString()) {
      case Annotation.agText:
        return TextFieldWriter(model, field);
      case Annotation.agBool:
        return BoolFieldWriter(model, field);
      case Annotation.agPassword:
        return PasswordFieldWriter(model, field);
      default:
        throw ArgumentError(
            '${field.formFieldAnnotation.type.getDisplayString()} is not supported');
    }
  }

  Spec writeAttributes() {
    String attributes = '';
    for (var attr in field.attributes) {
      switch (attr.name) {
        case AnnotationField.labelText:
        case AnnotationField.hintText:
        case AnnotationField.labelText:
        case AnnotationField.helperText:
          attributes +=
              StringFieldAttributeWriter(model, field, attr).write().toString();
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
      ..returns =
          refer('FormField<${field.fieldElement.type.getDisplayString()}>')
      ..body = writeBody()).toBuilder();
    return fieldBuilder.build();
  }
}

class TextFieldWriter extends FieldWriter {
  FieldWriter delegate;

  TextFieldWriter(Model model, ModelField field) : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        return AgTextField(
          ${writeAttributes()}
          onSaved: (newValue) {
            model.rebuild((b) => b.${field.name} = newValue);
          },
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

class BoolFieldWriter extends FieldWriter {
  FieldWriter delegate;

  BoolFieldWriter(Model model, ModelField field) : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        return AgCheckboxField(
          ${writeAttributes()}
          onSaved: (newValue) {
            model.rebuild((b) => b.${field.name} = newValue);
          },
        );
        ''',
      );
    });
  }

  @override
  Spec writeAttributes() {
    Spec attributes = delegate.writeAttributes();
    for (var attr in field.attributes) {
      if (attr.name == AnnotationField.initialValue) {
        attributes = Code(attributes.toString() +
            BoolFieldAttributeWriter(model, field, attr).write().toString());
        break;
      }
    }
    return attributes;
  }

  @override
  Spec write() {
    return delegate.write();
  }
}

class PasswordFieldWriter extends FieldWriter {
  FieldWriter delegate;

  PasswordFieldWriter(Model model, ModelField field) : super._(model, field) {
    delegate = BaseFieldWriter(model, field, writeBody: () {
      return Code(
        '''
        return AgPasswordField(
          ${writeAttributes()}
          onSaved: (newValue) {
            model.rebuild((b) => b.${field.name} = newValue);
          },
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
