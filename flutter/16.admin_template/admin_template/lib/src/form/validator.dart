import 'package:meta/meta.dart';

/// ===================================================================
/// Validators
/// ===================================================================

abstract class Validator<T> {
  Validator();

  String get property;
  String get error;

  String call(T value);
}

class CompositeValidator<T> implements Validator<T> {
  final String property;
  final List<Validator> validators;

  CompositeValidator({
    @required this.property,
    @required this.validators,
  });

  String call(T value) {
    for (final validator in validators) {
      var error = validator.call(value);
      if (error != null) return error;
    }
    return null;
  }

  @override
  String get error => null;
}

class RegExpValidator implements Validator<String> {
  final String pattern;
  final String property;
  final String error;

  RegExp get regExp => RegExp(pattern);

  RegExpValidator({
    @required this.pattern,
    @required this.property,
    String error,
  }) : this.error = error ?? '$pattern does not match.';

  @override
  String call(String value) {
    if (regExp.hasMatch(value)) return null;
    return error;
  }
}

class RequiredValidator implements Validator<dynamic> {
  final String property;
  final String error;

  RequiredValidator({
    @required this.property,
    String error,
  }) : this.error = error ?? '$property is required.';

  @override
  String call(dynamic value) {
    if (value is String && value == '') return error;
    if (value is Iterable && value.isEmpty) return error;
    if (value == null) return error;
    return null;
  }
}

class NameValidator extends RegExpValidator {
  NameValidator({
    @required String property,
    String error,
  }) : super(pattern: r'^[A-Za-z ]+$', property: property, error: error);
}

class EmailValidator extends RegExpValidator {
  EmailValidator({
    @required String property,
    String error,
  }) : super(
          pattern: r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
          property: property,
          error: error ?? 'E-mail is invalid.',
        );
}

class MinLengthValidator implements Validator<String> {
  final int minLength;
  final String property;
  final String error;

  MinLengthValidator(
    this.minLength, {
    this.property,
    String error,
  }) : this.error = error ?? '$property is too short.';

  @override
  String call(String value) {
    if (value.length < minLength) return error;
    return null;
  }
}
