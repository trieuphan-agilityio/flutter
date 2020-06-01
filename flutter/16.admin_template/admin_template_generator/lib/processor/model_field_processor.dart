import 'package:admin_template_annotation/admin_template_annotation.dart';
import 'package:admin_template_generator/misc/constants.dart';
import 'package:admin_template_generator/misc/type_utils.dart';
import 'package:admin_template_generator/processor/processor.dart';
import 'package:admin_template_generator/recase.dart';
import 'package:admin_template_generator/value_object/model_field.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

typedef AttributeGetter<T> = FieldAttribute<T> Function();

/// Extract information from [FieldElement] and abstract it in a plain model.
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
      case Annotation.agEmail:
        return EmailFieldProcessor._(fieldElement);
      case Annotation.agList:
        return CheckboxListFieldProcessor._(fieldElement);
      default:
        throw ArgumentError(
            '${annotation.type.getDisplayString()} is not supported.');
    }
  }

  ModelFieldProcessor._(this.fieldElement);

  static DartObject getFormFieldAnnotation(FieldElement fieldElement) =>
      fieldElement.getAnnotation(AgBase) ??
      fieldElement.getter.getAnnotation(AgBase);

  @override
  ModelField process() {
    final name = fieldElement.displayName;
    List<FieldAttribute> attributes = attributeGetters
        .map((attributeGetter) => attributeGetter.call())
        .where((e) => e != null)
        .toList();

    OnSavedModifier(name).applyTo(attributes);
    LabelTextModifier(name).applyTo(attributes);
    RequiredModifier(name).applyTo(attributes);
    MinLengthModifier(name).applyTo(attributes);

    // Attributes are sorted by name before writing to keep it consistent.
    attributes.sort((a, b) => a.name.compareTo(b.name));

    return ModelField(
      fieldElement,
      name,
      attributes: attributes,
      formFieldAnnotation: formFieldAnnotation,
    );
  }

  FieldAttribute<int> _getMinLengthAttr() {
    final value =
        formFieldAnnotation?.getField(FieldAnnotation.minLength)?.toIntValue();
    if (value == null) return null;
    return FieldAttribute<int>(FieldAnnotation.minLength, value);
  }

  FieldAttribute<int> _getMaxLengthAttr() {
    final value =
        formFieldAnnotation?.getField(FieldAnnotation.maxLength)?.toIntValue();
    if (value == null) return null;
    return FieldAttribute<int>(FieldAnnotation.maxLength, value);
  }

  FieldAttribute<bool> _getRequiredAttr() {
    final value =
        formFieldAnnotation?.getField(FieldAnnotation.required)?.toBoolValue();
    if (value == null) return null;
    return FieldAttribute<bool>(FieldAnnotation.required, value);
  }

  FieldAttribute<String> _getHintTextAttr() {
    final value = formFieldAnnotation
        ?.getField(FieldAnnotation.hintText)
        ?.toStringValue();
    if (value == null) return null;
    return FieldAttribute<String>(FieldAnnotation.hintText, value);
  }

  FieldAttribute<String> _getHelperTextAttr() {
    final value = formFieldAnnotation
        ?.getField(FieldAnnotation.helperText)
        ?.toStringValue();
    if (value == null) return null;
    return FieldAttribute<String>(FieldAnnotation.helperText, value);
  }

  FieldAttribute<String> _getLabelTextAttr() {
    final value = formFieldAnnotation
        ?.getField(FieldAnnotation.labelText)
        ?.toStringValue();
    if (value == null) return null;
    return FieldAttribute<String>(FieldAnnotation.labelText, value);
  }
}

/// ===================================================================
/// Model Field Modifier
/// ===================================================================

abstract class FieldAttributeModifier {
  void applyTo(List<FieldAttribute> attributes);
}

class OnSavedModifier implements FieldAttributeModifier {
  final String fieldName;

  OnSavedModifier(this.fieldName);

  @override
  void applyTo(List<FieldAttribute> attributes) {
    attributes.add(FieldAttribute<String>(
      FieldAnnotation.onSaved,
      '(newValue) { model = model.rebuild((b) => b.$fieldName = newValue); }',
    ));
  }
}

class RequiredModifier implements FieldAttributeModifier {
  final String fieldName;

  RequiredModifier(this.fieldName);

  @override
  void applyTo(List<FieldAttribute> attributes) {
    FieldAttribute<bool> required =
        attributes.findByName(FieldAnnotation.required);

    // skip this rule if required attribute is not specified
    if (required == null) return;

    // skip if required is false
    if (!required.value) return;

    // gonna convert required attribute to a validator
    attributes.remove(required);

    final validator = attributes.findByName(FieldAnnotation.validator);
    if (validator == null) {
      attributes.add(FieldAttribute<String>(
        FieldAnnotation.validator,
        'RequiredValidator(property: \'$fieldName\')',
      ));
    } else {
      // if validator is not configured yet, let's make a composite validator
      attributes.remove(validator);
      attributes.add(FieldAttribute<String>(
        FieldAnnotation.validator,
        """
        CompositeValidator(property: '$fieldName', validators: [
          RequiredValidator(property: '$fieldName'),
          ${validator.value},
        ])
        """,
      ));
    }
  }
}

/// If labelText is omitted, it will be filled with the name of field element.
class LabelTextModifier implements FieldAttributeModifier {
  final String fieldName;

  LabelTextModifier(this.fieldName);

  void applyTo(List<FieldAttribute<dynamic>> attributes) {
    final labelText = attributes.findByName(FieldAnnotation.labelText);

    // skip this rule
    if (labelText != null) return;

    attributes.add(FieldAttribute<String>(
      FieldAnnotation.labelText,
      fieldName.toTitleCase(),
    ));
  }
}

class MinLengthModifier implements FieldAttributeModifier {
  final String fieldName;

  MinLengthModifier(this.fieldName);

  @override
  void applyTo(List<FieldAttribute> attributes) {
    final minLength = attributes.findByName(FieldAnnotation.minLength);

    // skip if omit
    if (minLength == null) return;

    // convert minLength attribute to a validator
    attributes.remove(minLength);

    final validator = attributes.findByName(FieldAnnotation.validator);
    if (validator == null) {
      attributes.add(FieldAttribute<String>(
        FieldAnnotation.validator,
        'MinLengthValidator(${minLength.value}, property: \'$fieldName\')',
      ));
    } else {
      // if validator is not configured yet, let's make a composite validator
      attributes.remove(validator);
      attributes.add(FieldAttribute<String>(
        FieldAnnotation.validator,
        """
        CompositeValidator(property: '$fieldName', validators: [
          ${validator.value},
          MinLengthValidator(${minLength.value}, property: \'$fieldName\'),
        ])
        """,
      ));
    }
  }
}

/// ===================================================================
/// AgText
/// ===================================================================

class TextFieldProcessor extends ModelFieldProcessor with InitialStringValue {
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
}

/// ===================================================================
/// AgPassword
/// ===================================================================

class PasswordFieldProcessor extends ModelFieldProcessor
    with InitialStringValue {
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
}

/// ===================================================================
/// AgBool
/// ===================================================================

class BoolFieldProcessor extends ModelFieldProcessor with InitialBoolValue {
  BoolFieldProcessor._(FieldElement fieldElement) : super._(fieldElement);

  @override
  List<AttributeGetter> get attributeGetters => [
        _getRequiredAttr,
        _getInitialValueAttr,
        _getHintTextAttr,
        _getHelperTextAttr,
        _getLabelTextAttr,
      ];
}

/// ===================================================================
/// AgEmail
/// ===================================================================

class EmailFieldProcessor extends ModelFieldProcessor with InitialStringValue {
  EmailFieldProcessor._(FieldElement fieldElement) : super._(fieldElement);

  @override
  List<AttributeGetter> get attributeGetters => [
        _getRequiredAttr,
        _getInitialValueAttr,
        _getHintTextAttr,
        _getHelperTextAttr,
        _getLabelTextAttr,
        _getValidatorAttr,
      ];

  FieldAttribute<String> _getValidatorAttr() {
    final name = fieldElement.displayName;
    return FieldAttribute<String>(
        FieldAnnotation.validator, "EmailValidator(property: '$name')");
  }
}

/// ===================================================================
/// AgList
/// ===================================================================

class CheckboxListFieldProcessor extends ModelFieldProcessor
    with InitialListValue {
  CheckboxListFieldProcessor._(FieldElement fieldElement)
      : super._(fieldElement);

  @override
  List<AttributeGetter> get attributeGetters => [
        _getChoicesAttr,
        _getInitialValueAttr,
        _getRequiredAttr,
        _getHintTextAttr,
        _getHelperTextAttr,
        _getLabelTextAttr,
        _getChoiceTypeAttr,
      ];

  FieldAttribute<List<String>> _getChoicesAttr() {
    final value =
        formFieldAnnotation?.getField(FieldAnnotation.choices)?.toListValue();
    if (value == null) return null;

    // Read 'name' property from the instance of [EnumClass]'s subclass
    return FieldAttribute<List<String>>(
      FieldAnnotation.choices,
      value.map((e) => ConstantReader(e).read('name').stringValue).toList(),
    );
  }

  /// Metadata attribute that describes type of the [choices].
  FieldAttribute<String> _getChoiceTypeAttr() {
    final type = fieldElement.type.getDisplayString();

    String elementType;
    // verify list literal
    if (type.startsWith('BuiltList<') && type.endsWith('>')) {
      elementType = type.substring(10, type.length - 1);
    }

    assert(elementType != null);

    return FieldAttribute<String>(FieldMetadata.choiceType, elementType);
  }
}

/// ===================================================================
/// Mixin
/// ===================================================================

mixin InitialStringValue on ModelFieldProcessor {
  FieldAttribute<String> _getInitialValueAttr() {
    final value = formFieldAnnotation
        ?.getField(FieldAnnotation.initialValue)
        ?.toStringValue();

    final fieldName = fieldElement.displayName;

    if (value == null)
      return FieldAttribute<String>(
          FieldAnnotation.initialValue, 'model.$fieldName');

    return FieldAttribute<String>(
        FieldAnnotation.initialValue, "model.$fieldName ?? '$value'");
  }
}

mixin InitialBoolValue on ModelFieldProcessor {
  FieldAttribute<String> _getInitialValueAttr() {
    final value = formFieldAnnotation
        ?.getField(FieldAnnotation.initialValue)
        ?.toBoolValue();

    final fieldName = fieldElement.displayName;

    if (value == null)
      return FieldAttribute<String>(
          FieldAnnotation.initialValue, 'model.$fieldName');

    return FieldAttribute<String>(
        FieldAnnotation.initialValue, 'model.$fieldName ?? $value');
  }
}

mixin InitialListValue on ModelFieldProcessor {
  FieldAttribute<String> _getInitialValueAttr() {
    final value = formFieldAnnotation
        ?.getField(FieldAnnotation.initialValue)
        ?.toListValue();

    final fieldName = fieldElement.displayName;

    if (value == null)
      return FieldAttribute<String>(
          FieldAnnotation.initialValue, 'model.$fieldName');

    return FieldAttribute<String>(
        FieldAnnotation.initialValue, 'model.$fieldName ?? $value');
  }
}
