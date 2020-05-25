import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/misc/type_utils.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

typedef AttributeGetter<T> = FieldAttribute<T> Function();

abstract class ModelFieldProcessor implements Processor<ModelField> {
  final FieldElement fieldElement;

  List<AttributeGetter> get attributeGetters;

  /// A shortcut of [ModelFieldProcessor.getFormFieldAnnotation].
  DartObject get formFieldAnnotation => getFormFieldAnnotation(fieldElement);

  factory ModelFieldProcessor(FieldElement fieldElement) {
    final annotation = getFormFieldAnnotation(fieldElement);
    assert(annotation != null, 'annotation must not be null.');

    switch (annotation.type.getDisplayString()) {
      case Annotation.agText:
        return TextFieldProcessor._(fieldElement);
      case Annotation.agPassword:
        return PasswordFieldProcessor._(fieldElement);
      case Annotation.agBool:
        return BoolFieldProcessor._(fieldElement);
      default:
        throw ArgumentError(
            '${fieldElement.type.getDisplayString()} is not supported.');
    }
  }

  ModelFieldProcessor._(this.fieldElement);

  static DartObject getFormFieldAnnotation(FieldElement fieldElement) =>
      fieldElement.getAnnotation(AgBase) ??
      fieldElement.getter.getAnnotation(AgBase);

  @override
  ModelField process() {
    final name = fieldElement.displayName;
    return ModelField(
      fieldElement,
      name,
      attributes: attributeGetters
          .map((getter) => getter.call())
          .where((e) => e != null)
          .toList(),
      formFieldAnnotation: formFieldAnnotation,
    );
  }

  FieldAttribute<int> _getMinLengthAttr() {
    final value =
        formFieldAnnotation?.getField(AnnotationField.minLength)?.toIntValue();

    if (value == null) return null;

    return FieldAttribute<int>(AnnotationField.minLength, value);
  }

  FieldAttribute<int> _getMaxLengthAttr() {
    final value =
        formFieldAnnotation?.getField(AnnotationField.maxLength)?.toIntValue();

    if (value == null) return null;

    return FieldAttribute<int>(AnnotationField.maxLength, value);
  }

  FieldAttribute<bool> _getRequiredAttr() {
    final value =
        formFieldAnnotation?.getField(AnnotationField.required)?.toBoolValue();

    if (value == null) return null;

    return FieldAttribute<bool>(AnnotationField.required, value);
  }

  FieldAttribute<String> _getHintTextAttr() {
    final value = formFieldAnnotation
        ?.getField(AnnotationField.hintText)
        ?.toStringValue();

    if (value == null) return null;

    return FieldAttribute<String>(AnnotationField.hintText, value);
  }

  FieldAttribute<String> _getHelperTextAttr() {
    final value = formFieldAnnotation
        ?.getField(AnnotationField.helperText)
        ?.toStringValue();

    if (value == null) return null;

    return FieldAttribute<String>(AnnotationField.helperText, value);
  }

  FieldAttribute<String> _getLabelTextAttr() {
    final value = formFieldAnnotation
        ?.getField(AnnotationField.labelText)
        ?.toStringValue();

    if (value == null) return null;

    return FieldAttribute<String>(AnnotationField.labelText, value);
  }
}

class TextFieldProcessor extends ModelFieldProcessor {
  @override
  TextFieldProcessor._(FieldElement fieldElement) : super._(fieldElement);

  @override
  List<AttributeGetter> get attributeGetters => [
        _getMinLengthAttr,
        _getMaxLengthAttr,
        _getRequiredAttr,
        _getInitialValueAttr,
        _getHintTextAttr,
        _getHelperTextAttr,
        _getLabelTextAttr,
      ];

  FieldAttribute<String> _getInitialValueAttr() {
    final value = formFieldAnnotation
        ?.getField(AnnotationField.initialValue)
        ?.toStringValue();

    if (value == null) return null;

    return FieldAttribute<String>(AnnotationField.initialValue, value);
  }
}

class PasswordFieldProcessor extends ModelFieldProcessor {
  @override
  PasswordFieldProcessor._(FieldElement fieldElement) : super._(fieldElement);

  @override
  List<AttributeGetter> get attributeGetters => [
        _getMinLengthAttr,
        _getMaxLengthAttr,
        _getRequiredAttr,
        _getInitialValueAttr,
        _getHintTextAttr,
        _getHelperTextAttr,
        _getLabelTextAttr,
      ];

  FieldAttribute<String> _getInitialValueAttr() {
    final value = formFieldAnnotation
        ?.getField(AnnotationField.initialValue)
        ?.toStringValue();

    if (value == null) return null;

    return FieldAttribute<String>(AnnotationField.initialValue, value);
  }
}

class BoolFieldProcessor extends ModelFieldProcessor {
  @override
  BoolFieldProcessor._(FieldElement fieldElement) : super._(fieldElement);

  @override
  List<AttributeGetter> get attributeGetters => [
        _getRequiredAttr,
        _getInitialValueAttr,
        _getHintTextAttr,
        _getHelperTextAttr,
        _getLabelTextAttr,
      ];

  FieldAttribute<bool> _getInitialValueAttr() {
    final value = formFieldAnnotation
        ?.getField(AnnotationField.initialValue)
        ?.toBoolValue();

    if (value == null) return null;

    return FieldAttribute<bool>(AnnotationField.initialValue, value);
  }
}
