import 'package:admin_template_core/core.dart';
import 'package:built_value/built_value.dart';

part 'field_template.g.dart';

abstract class AgFieldTemplate<T>
    implements Built<AgFieldTemplate<T>, AgFieldTemplateBuilder<T>> {
  AgFieldTemplate._();
  factory AgFieldTemplate([void Function(AgFieldTemplateBuilder<T>) updates]) =
      _$AgFieldTemplate<T>;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  T get initialValue;
}

abstract class AgTextTemplate
    implements Built<AgTextTemplate, AgTextTemplateBuilder> {
  AgTextTemplate._();
  factory AgTextTemplate([void Function(AgTextTemplateBuilder) updates]) =
      _$AgTextTemplate;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  String get initialValue;
  int get minLength;
  int get maxLength;
}

abstract class AgEmailTemplate
    implements Built<AgEmailTemplate, AgEmailTemplateBuilder> {
  AgEmailTemplate._();
  factory AgEmailTemplate([void Function(AgEmailTemplateBuilder) updates]) =
      _$AgEmailTemplate;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  String get initialValue;
  String get pattern;
}

abstract class AgBoolTemplate
    implements Built<AgBoolTemplate, AgBoolTemplateBuilder> {
  AgBoolTemplate._();
  factory AgBoolTemplate([void Function(AgBoolTemplateBuilder) updates]) =
      _$AgBoolTemplate;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  bool get initialValue;
}

abstract class AgIntTemplate
    implements Built<AgIntTemplate, AgIntTemplateBuilder> {
  AgIntTemplate._();
  factory AgIntTemplate([void Function(AgIntTemplateBuilder) updates]) =
      _$AgIntTemplate;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  int get initialValue;
  int get minLength;
  int get maxLength;
}

abstract class AgDateRangeTemplate
    implements Built<AgDateRangeTemplate, AgDateRangeTemplateBuilder> {
  AgDateRangeTemplate._();
  factory AgDateRangeTemplate(
          [void Function(AgDateRangeTemplateBuilder) updates]) =
      _$AgDateRangeTemplate;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  DateTimeRange get initialValue;
  DateTime get min;
  DateTime get max;
}

abstract class AgSecureTemplate
    implements Built<AgSecureTemplate, AgSecureTemplateBuilder> {
  AgSecureTemplate._();
  factory AgSecureTemplate([void Function(AgSecureTemplateBuilder) updates]) =
      _$AgSecureTemplate;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  String get initialValue;
  int get minLength;
  int get maxLength;
  String get maskCharacter => '*';
}

abstract class AgListTemplate<T>
    implements Built<AgListTemplate<T>, AgListTemplateBuilder<T>> {
  AgListTemplate._();
  factory AgListTemplate([void Function(AgListTemplateBuilder<T>) updates]) =
      _$AgListTemplate<T>;

  bool get isRequired;
  String get hintText;
  String get labelText;
  String get helperText;

  Iterable<T> get initialValue;
  Iterable<T> get choices;
}
