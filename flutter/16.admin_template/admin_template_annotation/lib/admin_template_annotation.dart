import 'package:meta/meta.dart';

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

abstract class AgBase<T> {
  T get initialValue;
  bool get required;
  String get hintText;
  String get labelText;
  String get helperText;
}

class AgText implements AgBase<String> {
  final int minLength;
  final int maxLength;
  final String initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgText({
    this.minLength,
    this.maxLength,
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

class AgPassword implements AgBase<String> {
  final int minLength;
  final int maxLength;
  final String initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgPassword({
    this.minLength,
    this.maxLength,
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

class AgEmail implements AgBase<String> {
  final String pattern;
  final String initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgEmail({
    this.pattern,
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

class AgRelated<T> implements AgBase<T> {
  final T initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgRelated({
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

class AgBool implements AgBase<bool> {
  final bool initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgBool({
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

class AgInt implements AgBase<int> {
  final int minLength;
  final int maxLength;
  final int initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgInt({
    this.minLength,
    this.maxLength,
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

class AgList implements AgBase<List<String>> {
  final List<String> choices;
  final List<String> initialValue;
  final bool required;
  final String hintText;
  final String labelText;
  final String helperText;

  const AgList({
    this.choices,
    this.initialValue,
    this.required,
    this.hintText,
    this.labelText,
    this.helperText,
  });
}

/// ===================================================================
/// Form
/// ===================================================================

/// An annotation to instruct the generator build code for creating/edit form
class AgForm {
  final Type modelType;
  const AgForm({this.modelType});
}
