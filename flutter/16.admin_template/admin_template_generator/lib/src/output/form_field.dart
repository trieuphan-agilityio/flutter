import 'package:analyzer/dart/ast/ast.dart' as ast;
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';
import 'package:admin_template_core/core.dart';

enum FieldType { text, int, date, bool, listBool }

const kInitialValueStr = 'initialValue';
const kIsRequiredStr = 'isRequired';
const kLabelTextStr = 'labelText';
const kHintTextStr = 'hintText';
const kOnSavedStr = 'onSaved';
const kMaxLengthStr = 'maxLength';
const kMinLengthStr = 'minLength';
const kMinStr = 'min';
const kMaxStr = 'max';
const kValidatorStr = 'validator';
const kPropertyStr = 'property';
const kValidatorsStr = 'validators';

const kAgTextFieldRef = Reference('AgTextField');
const kAgCheckboxFieldRef = Reference('AgCheckboxField');
const kAgCheckboxListFieldRef = Reference('AgCheckboxListField');

const kRequiredValidatorRef = Reference('RequiredValidator');
const kCompositeValidatorRef = Reference('CompositeValidator');
const kDynamicValidatorRef = Reference('Validator<dynamic>');

abstract class FormField {
  /// Name of the form field, it's same to the corresponding model field.
  String get name;

  /// Attributes that comes from AST node that parsed from the field template.
  Map<String, ast.Expression> get inputAttrs;

  /// Reference of the value type.
  ///
  /// Every form field have a value type. There are fields that have obvious
  /// value type such as AgTextField, AgCheckboxField and AgDateRangeField.
  ///
  /// There are also field that require explicitly specify the value type such
  /// as AgCheckboxListField<T> and AgRelatedField<T>.
  ///
  /// If the value type is implicit, this field should be null.
  Reference get valueTypeRef => null;

  /// Reference to Flutter widget that represents this form field on widget tree.
  Reference get widgetRef;

  const FormField();

  factory FormField.text(String name, Map<String, ast.Expression> attrs) =>
      TextField(name, attrs);

  factory FormField.bool(String name, Map<String, ast.Expression> attrs) =>
      CheckboxField(name, attrs);

  factory FormField.list(
    String name,
    Map<String, ast.Expression> attrs,
    Reference valueTypeRef,
  ) =>
      CheckboxListField(name, attrs, valueTypeRef);

  Expression toWidgetExpression() {
    var args = BuiltMap<String, Expression>.from({});

    for (final e in inputAttrs.entries) {
      switch (e.key) {
        case kInitialValueStr:
          args = args.rebuild((b) => transformInitialValue(e.key, e.value, b));
          break;

        case kIsRequiredStr:
          args = args.rebuild((b) => transformIsRequired(e.key, e.value, b));
          break;

        case kLabelTextStr:
          args = args.rebuild((b) => transformLabelText(e.key, e.value, b));
          break;

        case kHintTextStr:
          args = args.rebuild((b) => transformHintText(e.key, e.value, b));
          break;

        case kOnSavedStr:
          args = args.rebuild((b) => transformOnSaved(e.key, e.value, b));
          break;

        case kMaxLengthStr:
          args = args.rebuild((b) => transformMaxLength(e.key, e.value, b));
          break;

        case kMinLengthStr:
          args = args.rebuild((b) => transformMinLength(e.key, e.value, b));
          break;

        case kMinStr:
          args = args.rebuild((b) => transformMin(e.key, e.value, b));
          break;

        case kMaxStr:
          args = args.rebuild((b) => transformMax(e.key, e.value, b));
          break;

        default:
          // Other property would be transformed identically to the syntax
          // in form field template.
          args = args.rebuild(
            (b) => b..putIfAbsent(e.key, () => _identical(e.value)),
          );
      }
    }

    // inject default value for initialValue and onSaved if missing
    args = args.rebuild((b) => b
      ..putIfAbsent(kInitialValueStr, () => makeInitialValue(name))
      ..putIfAbsent(kOnSavedStr, () => makeOnSaved(name))
      ..putIfAbsent(kLabelTextStr, () => makeLabelText(name)));

    return widgetRef.call([], args.asMap());
  }

  transformInitialValue(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kInitialValueStr, () => handleInitialValue(astExpr));

  transformIsRequired(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) {
    final currentValidator = builder.remove(kValidatorStr);
    final requiredValidatorExpr = InvokeExpression.constOf(
      kRequiredValidatorRef,
      [],
      {kPropertyStr: literalString(name)},
      const [],
    );

    if (currentValidator == null) {
      builder.putIfAbsent(kValidatorStr, () => requiredValidatorExpr);
    } else {
      builder.putIfAbsent(
        kValidatorStr,
        () => InvokeExpression.constOf(
          kCompositeValidatorRef,
          [],
          {
            kPropertyStr: literalString(name),
            kValidatorsStr: literalList(
              [currentValidator, requiredValidatorExpr],
              kDynamicValidatorRef,
            ),
          },
          const [],
        ),
      );
    }
  }

  transformLabelText(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kLabelTextStr, () => handleLabelText(astExpr));

  transformHintText(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kHintTextStr, () => handleHintText(astExpr));

  transformOnSaved(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kOnSavedStr, () => handleOnSaved(astExpr));

  transformMaxLength(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kMaxLengthStr, () => handleMaxLength(astExpr));

  transformMinLength(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kMinLengthStr, () => handleMinLength(astExpr));

  transformMin(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kMinStr, () => handleMin(astExpr));

  transformMax(
    String propertyName,
    ast.Expression astExpr,
    MapBuilder<String, Expression> builder,
  ) =>
      builder.putIfAbsent(kMaxStr, () => handleMax(astExpr));

  Expression handleInitialValue(ast.Expression astExpr) => _identical(astExpr);

  Expression handleIsRequired(ast.Expression astExpr) => _identical(astExpr);

  Expression handleLabelText(ast.Expression astExpr) => _identical(astExpr);

  Expression handleHintText(ast.Expression astExpr) => _identical(astExpr);

  Expression handleOnSaved(ast.Expression astExpr) => _identical(astExpr);

  Expression handleMaxLength(ast.Expression astExpr) => _identical(astExpr);

  Expression handleMinLength(ast.Expression astExpr) => _identical(astExpr);

  Expression handleMin(ast.Expression astExpr) => _identical(astExpr);

  Expression handleMax(ast.Expression astExpr) => _identical(astExpr);

  Expression _identical(ast.Expression astExpr) =>
      CodeExpression(Code(astExpr.toSource()));

  Spec makeInitialValue(String propertyName) {
    return refer('model').property(propertyName);
  }

  Spec makeOnSaved(String propertyName) {
    return Method(
      (b) => b
        ..requiredParameters.add(Parameter((b) => b..name = 'newValue'))
        ..body = refer('model')
            .assign(refer('model').property('copyWith').call(
              [],
              {propertyName: refer('newValue')},
            ))
            .statement,
    ).closure;
  }

  Spec makeLabelText(String propertyName) {
    return literalString(propertyName.toTitleCase());
  }
}

class TextField extends FormField {
  final String name;
  final Map<String, ast.Expression> inputAttrs;

  const TextField(this.name, this.inputAttrs);

  @override
  Reference get widgetRef => kAgTextFieldRef;
}

class CheckboxField extends FormField {
  final String name;
  final Map<String, ast.Expression> inputAttrs;

  const CheckboxField(this.name, this.inputAttrs);

  @override
  Reference get widgetRef => kAgCheckboxFieldRef;
}

class CheckboxListField extends FormField {
  final String name;
  final Map<String, ast.Expression> inputAttrs;

  const CheckboxListField(this.name, this.inputAttrs, Reference valueTypeRef)
      : _valueTypeRef = valueTypeRef;

  @override
  Reference get widgetRef => kAgCheckboxListFieldRef;

  @override
  Reference get valueTypeRef => _valueTypeRef;

  /// Backing field of [valueTypeRef]
  final Reference _valueTypeRef;
}
