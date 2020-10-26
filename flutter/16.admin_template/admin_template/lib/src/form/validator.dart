import 'package:admin_template_core/core.dart';
import 'package:meta/meta.dart';

/// ===================================================================
/// Validators
/// ===================================================================

abstract class Validator<T> {
  Validator();

  String get property;
  String get error;

  String call(T value);

  factory Validator.dateRange({
    @required String property,
    DateTime start,
    DateTime end,
    Validator<dynamic> additionalValidator,
  }) {
    return CompositeValidator(
      property: property,
      validators: List<Validator<dynamic>>()
        ..add(additionalValidator)
        ..add(DateRangeValidator(property: property, start: start, end: end)),
    );
  }
}

class DateRangeValidator implements Validator<DateTimeRange> {
  final String property;
  final DateTime start;
  final DateTime end;
  final String error;

  DateRangeValidator({
    @required this.property,
    @required this.start,
    @required this.end,
    String error,
  })  : error = error ?? 'Selected dates are not in range.',
        assert(start.isBefore(end), 'start must be before end.');

  @override
  String call(DateTimeRange value) {
    const aDay = Duration(days: 1);
    if (value.start.isBefore(start.subtract(aDay)) ||
        value.end.isAfter(end.add(aDay))) return error;
    return null;
  }
}

class CompositeValidator<T> implements Validator<T> {
  final String property;
  final List<Validator> validators;
  String _error;

  CompositeValidator({@required this.property, @required this.validators});

  String call(T value) {
    for (final validator in validators) {
      var error = validator.call(value);
      if (error != null) {
        _error = error;
        return error;
      }
    }
    _error = null;
    return null;
  }

  String get error => _error;
}

class RegExpValidator implements Validator<String> {
  final String property;
  final String pattern;
  final String _error;

  const RegExpValidator({
    @required this.property,
    @required this.pattern,
    String error,
  }) : _error = error;

  String get error => _error ?? '$pattern does not match.';

  RegExp get regExp => RegExp(pattern);

  @override
  String call(String value) {
    if (regExp.hasMatch(value)) return null;
    return error;
  }
}

class RequiredValidator implements Validator<dynamic> {
  final String property;
  final String _error;

  const RequiredValidator({@required this.property, String error})
      : this._error = error;

  String get error => _error ?? '${property.toTitleCase()} is required.';

  @override
  String call(dynamic value) {
    if (value is String && value == '') return error;
    if (value is Iterable && value.isEmpty) return error;
    if (value == null) return error;
    return null;
  }
}

class NameValidator extends RegExpValidator {
  const NameValidator({
    @required String property,
    String error,
  }) : super(pattern: r'^[A-Za-z ]+$', property: property, error: error);
}

class EmailValidator extends RegExpValidator {
  const EmailValidator({
    @required String property,
    String error,
  })  : _error = error,
        super(
          pattern: r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$',
          property: property,
          error: error,
        );

  final String _error;

  @override
  String get error => _error ?? 'E-mail is invalid.';
}

class MinLengthValidator implements Validator<String> {
  final String property;
  final int minLength;
  final String _error;

  const MinLengthValidator({
    @required this.minLength,
    @required this.property,
    String error,
  }) : this._error = error;

  String get error => _error ?? '${property.toTitleCase()} is too short.';

  @override
  String call(String value) {
    if (value.length < minLength) return error;
    return null;
  }
}
