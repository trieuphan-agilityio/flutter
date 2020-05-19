import 'package:meta/meta.dart';

class AgEmail {
  const AgEmail._();
}

const AgEmail agEmail = AgEmail._();

class AgName {
  const AgName._();
}

const AgName agName = AgName._();

class AgPhone {
  final String countryCode;
  const AgPhone({this.countryCode});
}

class AgMatch {
  final String otherProperty;
  const AgMatch({@required this.otherProperty});
}

class AgMax {
  final int value;
  const AgMax(this.value);
}

class AgMin {
  final int value;
  const AgMin(this.value);
}

class AgRegex {
  final int pattern;
  const AgRegex({@required this.pattern});
}

class AgRequired {
  const AgRequired._();
}

const AgRequired agRequired = AgRequired._();

class AgMask {
  final String pattern;
  const AgMask({@required this.pattern});
}

class AgRegExp {
  final String pattern;
  const AgRegExp({@required this.pattern});
}

/// ===================================================================
/// Field Metadata
/// ===================================================================

abstract class _AgBase {
  final bool required;
  final int minLength;
  final int maxLength;
  final String hintText;
  final String labelText;
  final String helperText;
  final List<Validator> _validators;

  List<Validator> get defaultValidators;

  List<Validator> get validators {
    return defaultValidators + _validators;
  }

  const _AgBase({
    this.required,
    this.minLength,
    this.maxLength,
    this.hintText,
    this.labelText,
    this.helperText,
    List<Validator> validators,
  }) : _validators = validators;
}

class AgText extends _AgBase {
  const AgText({
    bool required,
    int minLength,
    int maxLength,
    String hintText,
    String labelText,
    String helperText,
    List<Validator> validators,
  }) : super(
          minLength: minLength,
          maxLength: maxLength,
          required: required,
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          validators: validators,
        );

  @override
  List<Validator> get defaultValidators => [];
}

class AgPassword extends _AgBase {
  const AgPassword({
    bool required,
    int minLength,
    int maxLength,
    String hintText,
    String labelText,
    String helperText,
    List<Validator> validators,
  }) : super(
          required: required,
          minLength: minLength,
          maxLength: maxLength,
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          validators: validators,
        );

  @override
  List<Validator> get defaultValidators => [];
}

class AgRelated extends _AgBase {
  const AgRelated({
    bool required,
    String hintText,
    String labelText,
    String helperText,
    List<Validator> validators,
  }) : super(
          required: required,
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          validators: validators,
        );

  @override
  List<Validator> get defaultValidators => [];
}

/// ===================================================================
/// Form
/// ===================================================================

class AgEditForm {
  const AgEditForm._();
}

/// An annotation to instruct the generator build code for editing form
const AgEditForm agEditForm = AgEditForm._();

/// ===================================================================
/// Validators
/// ===================================================================
typedef PropertyResolver<M, P> = P Function(M);

abstract class Validator<M, P> {
  const Validator();

  PropertyResolver<M, P> get propertyResolver;

  String validate(M model);
}

class RegExpValidator<M> implements Validator<M, String> {
  final PropertyResolver<M, String> _propertyResolver;
  final String pattern;

  RegExp get regExp => RegExp(pattern);

  const RegExpValidator({
    this.pattern,
    PropertyResolver<M, String> propertyResolver,
  }) : _propertyResolver = propertyResolver;

  @override
  PropertyResolver<M, String> get propertyResolver => _propertyResolver;

  @override
  String validate(M model) {
    final String value = propertyResolver(model);
    if (regExp.hasMatch(value)) return '$regExp does not match.';
    return null;
  }
}

class NameValidator<M> extends RegExpValidator<M> {
  const NameValidator({
    PropertyResolver<M, String> propertyResolver,
  }) : super(
          pattern: r'^[A-Za-z ]+$',
          propertyResolver: propertyResolver,
        );
}

class EmailValidator<M> extends RegExpValidator<M> {
  const EmailValidator({
    PropertyResolver<M, String> propertyResolver,
  }) : super(
          pattern: r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
          propertyResolver: propertyResolver,
        );
}
