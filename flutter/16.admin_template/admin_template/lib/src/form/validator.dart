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

  RequiredValidator({@required this.property, String error})
      : this.error = error ?? '$property is required.';

  @override
  String call(dynamic value) {
    if (value == null) return error;
    return null;
  }
}

class NameValidator extends RegExpValidator {
  NameValidator({@required String property, String error})
      : super(pattern: r'^[A-Za-z ]+$', property: property, error: error);
}

class EmailValidator extends RegExpValidator {
  EmailValidator({@required String property, String error})
      : super(
          pattern: r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
          property: property,
          error: error ?? 'E-mail is invalid.',
        );
}
