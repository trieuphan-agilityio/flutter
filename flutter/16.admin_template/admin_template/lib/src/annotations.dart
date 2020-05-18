import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'models/validators.dart';

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

class AgPassword {
  const AgPassword._();
}

const AgPassword agPassword = AgPassword._();

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

@immutable
class AgField {
  final String hintText;
  final String labelText;
  final String helperText;
  final List<Validator> _validators;

  static List<Validator> defaultValidators = [];

  List<Validator> get validators {
    return defaultValidators + _validators;
  }

  const AgField({
    this.hintText,
    this.labelText,
    this.helperText,
    List<Validator> validators,
  }) : _validators = validators;
}

var field = AgField();

@immutable
class AgCharField implements AgField {
  final AgField _field;
  final int maxLength;
  final List<Validator> _validators;

  static List<Validator> defaultValidators = [];

  AgCharField({
    @required this.maxLength,
    String hintText,
    String labelText,
    String helperText,
    List<Validator> validators,
  })  : _validators = validators,
        _field = AgField(
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          validators: validators,
        );

  @override
  String get helperText => _field.helperText;

  @override
  String get hintText => _field.hintText;

  @override
  String get labelText => _field.labelText;

  @override
  List<Validator> get validators {
    return defaultValidators + _validators;
  }
}
