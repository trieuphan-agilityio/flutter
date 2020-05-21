import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/value_object/model.dart';
import 'package:admin_template_generator/writer/writer.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';
import 'package:meta/meta.dart';

/// Creates the implementation of a Form field
abstract class FieldWriter extends Writer {
  final ModelField field;

  /// Keep a reference to the origin model
  final Model model;

  FieldWriter._(this.field, this.model);

  factory FieldWriter(ModelField field, Model model) {
    switch (field.formFieldAnnotation.name) {
      case Annotation.agText:
        return TextFieldWriter(field, model);
      case Annotation.agBool:
        return BoolFieldWriter(field, model);
      case Annotation.agPassword:
        return PasswordFieldWriter(field, model);
      default:
        throw ArgumentError(
            '${field.formFieldAnnotation.name} is not supported');
    }
  }
}

typedef WriteBody = Spec Function();

class BaseFieldWriter extends FieldWriter {
  final WriteBody writeBody;

  BaseFieldWriter(
    ModelField field,
    Model model, {
    @required this.writeBody,
  }) : super._(field, model);

  @override
  Spec write() {
    final fieldBuilder = Method((b) => b
      ..annotations.add(CodeExpression(Code('override')))
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

  TextFieldWriter(
    ModelField field,
    Model model,
  ) : super._(field, model) {
    delegate = BaseFieldWriter(field, model, writeBody: () {
      String labelText = 'labelText: \'${field.name}\',';
      String helperText = '';

      assert(labelText == '' || labelText.endsWith(','));
      assert(helperText == '' || helperText.endsWith(','));

      return Code(
        '''
        return AgTextField(
          $labelText
          $helperText
          onSaved: (newValue) {
            model.rebuild((b) => b.${field.name} = newValue);
          },
          validator: (value) {
            final validator = NameValidator<${model.name}>(propertyResolver: (m) {
              return m.${field.name};
            });
            return validator.validate(model);
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

  BoolFieldWriter(
    ModelField field,
    Model model,
  ) : super._(field, model) {
    delegate = BaseFieldWriter(field, model, writeBody: () {
      String labelText = 'labelText: \'Is default site\',';
      String helperText =
          'helperText: \'If true, this site will handle request for all other '
          'hostnames that do not have a site entry of their own.\',';

      assert(labelText == '' || labelText.endsWith(','));
      assert(helperText == '' || helperText.endsWith(','));

      return Code(
        '''
        return AgCheckboxField(
          initialValue: true,
          $labelText
          $helperText
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

class PasswordFieldWriter extends FieldWriter {
  FieldWriter delegate;

  PasswordFieldWriter(
    ModelField field,
    Model model,
  ) : super._(field, model) {
    delegate = BaseFieldWriter(field, model, writeBody: () {
      String labelText = 'labelText: \'${field.name}\',';
      String helperText = '';

      assert(labelText == '' || labelText.endsWith(','));
      assert(helperText == '' || helperText.endsWith(','));

      return Code(
        '''
        return AgPasswordField(
          $labelText
          $helperText
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
