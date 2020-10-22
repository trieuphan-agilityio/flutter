import 'package:analyzer/dart/ast/ast.dart' as ast;
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/base.dart';

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
const kRequiredValidatorRef = Reference('RequiredValidator');
const kCompositeValidatorRef = Reference('CompositeValidator');
const kDynamicValidatorRef = Reference('Validator<dynamic>');

abstract class FormField {
  /// Name of the form field, it's same to the corresponding model field.
  String get name;

  /// Attributes that comes from AST node that parsed from the field template.
  Map<String, ast.Expression> get inputAttrs;

  /// Reference to Flutter widget that represents this form field on widget tree.
  Reference get widgetRef;

  const FormField();

  factory FormField.text(String name, Map<String, ast.Expression> attrs) {
    return TextField(name, attrs);
  }

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
      ..putIfAbsent(kOnSavedStr, () => makeOnSaved(name)));

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
}

class TextField extends FormField {
  final String name;
  final Map<String, ast.Expression> inputAttrs;

  const TextField(this.name, this.inputAttrs);

  @override
  Reference get widgetRef => kAgTextFieldRef;
}
