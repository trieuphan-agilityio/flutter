// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_template.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AgFieldTemplate<T> extends AgFieldTemplate<T> {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final T initialValue;

  factory _$AgFieldTemplate(
          [void Function(AgFieldTemplateBuilder<T>) updates]) =>
      (new AgFieldTemplateBuilder<T>()..update(updates)).build();

  _$AgFieldTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgFieldTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgFieldTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgFieldTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgFieldTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgFieldTemplate', 'initialValue');
    }
    if (T == dynamic) {
      throw new BuiltValueMissingGenericsError('AgFieldTemplate', 'T');
    }
  }

  @override
  AgFieldTemplate<T> rebuild(
          void Function(AgFieldTemplateBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgFieldTemplateBuilder<T> toBuilder() =>
      new AgFieldTemplateBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgFieldTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                labelText.hashCode),
            helperText.hashCode),
        initialValue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgFieldTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue))
        .toString();
  }
}

class AgFieldTemplateBuilder<T>
    implements Builder<AgFieldTemplate<T>, AgFieldTemplateBuilder<T>> {
  _$AgFieldTemplate<T> _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  T _initialValue;
  T get initialValue => _$this._initialValue;
  set initialValue(T initialValue) => _$this._initialValue = initialValue;

  AgFieldTemplateBuilder();

  AgFieldTemplateBuilder<T> get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgFieldTemplate<T> other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgFieldTemplate<T>;
  }

  @override
  void update(void Function(AgFieldTemplateBuilder<T>) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgFieldTemplate<T> build() {
    final _$result = _$v ??
        new _$AgFieldTemplate<T>._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue);
    replace(_$result);
    return _$result;
  }
}

class _$AgTextTemplate extends AgTextTemplate {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final String initialValue;
  @override
  final int minLength;
  @override
  final int maxLength;

  factory _$AgTextTemplate([void Function(AgTextTemplateBuilder) updates]) =>
      (new AgTextTemplateBuilder()..update(updates)).build();

  _$AgTextTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue,
      this.minLength,
      this.maxLength})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'initialValue');
    }
    if (minLength == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'minLength');
    }
    if (maxLength == null) {
      throw new BuiltValueNullFieldError('AgTextTemplate', 'maxLength');
    }
  }

  @override
  AgTextTemplate rebuild(void Function(AgTextTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgTextTemplateBuilder toBuilder() =>
      new AgTextTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgTextTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue &&
        minLength == other.minLength &&
        maxLength == other.maxLength;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                        labelText.hashCode),
                    helperText.hashCode),
                initialValue.hashCode),
            minLength.hashCode),
        maxLength.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgTextTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue)
          ..add('minLength', minLength)
          ..add('maxLength', maxLength))
        .toString();
  }
}

class AgTextTemplateBuilder
    implements Builder<AgTextTemplate, AgTextTemplateBuilder> {
  _$AgTextTemplate _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  String _initialValue;
  String get initialValue => _$this._initialValue;
  set initialValue(String initialValue) => _$this._initialValue = initialValue;

  int _minLength;
  int get minLength => _$this._minLength;
  set minLength(int minLength) => _$this._minLength = minLength;

  int _maxLength;
  int get maxLength => _$this._maxLength;
  set maxLength(int maxLength) => _$this._maxLength = maxLength;

  AgTextTemplateBuilder();

  AgTextTemplateBuilder get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _minLength = _$v.minLength;
      _maxLength = _$v.maxLength;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgTextTemplate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgTextTemplate;
  }

  @override
  void update(void Function(AgTextTemplateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgTextTemplate build() {
    final _$result = _$v ??
        new _$AgTextTemplate._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue,
            minLength: minLength,
            maxLength: maxLength);
    replace(_$result);
    return _$result;
  }
}

class _$AgEmailTemplate extends AgEmailTemplate {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final String initialValue;
  @override
  final String pattern;

  factory _$AgEmailTemplate([void Function(AgEmailTemplateBuilder) updates]) =>
      (new AgEmailTemplateBuilder()..update(updates)).build();

  _$AgEmailTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue,
      this.pattern})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgEmailTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgEmailTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgEmailTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgEmailTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgEmailTemplate', 'initialValue');
    }
    if (pattern == null) {
      throw new BuiltValueNullFieldError('AgEmailTemplate', 'pattern');
    }
  }

  @override
  AgEmailTemplate rebuild(void Function(AgEmailTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgEmailTemplateBuilder toBuilder() =>
      new AgEmailTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgEmailTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue &&
        pattern == other.pattern;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                    labelText.hashCode),
                helperText.hashCode),
            initialValue.hashCode),
        pattern.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgEmailTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue)
          ..add('pattern', pattern))
        .toString();
  }
}

class AgEmailTemplateBuilder
    implements Builder<AgEmailTemplate, AgEmailTemplateBuilder> {
  _$AgEmailTemplate _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  String _initialValue;
  String get initialValue => _$this._initialValue;
  set initialValue(String initialValue) => _$this._initialValue = initialValue;

  String _pattern;
  String get pattern => _$this._pattern;
  set pattern(String pattern) => _$this._pattern = pattern;

  AgEmailTemplateBuilder();

  AgEmailTemplateBuilder get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _pattern = _$v.pattern;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgEmailTemplate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgEmailTemplate;
  }

  @override
  void update(void Function(AgEmailTemplateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgEmailTemplate build() {
    final _$result = _$v ??
        new _$AgEmailTemplate._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue,
            pattern: pattern);
    replace(_$result);
    return _$result;
  }
}

class _$AgBoolTemplate extends AgBoolTemplate {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final bool initialValue;

  factory _$AgBoolTemplate([void Function(AgBoolTemplateBuilder) updates]) =>
      (new AgBoolTemplateBuilder()..update(updates)).build();

  _$AgBoolTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgBoolTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgBoolTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgBoolTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgBoolTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgBoolTemplate', 'initialValue');
    }
  }

  @override
  AgBoolTemplate rebuild(void Function(AgBoolTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgBoolTemplateBuilder toBuilder() =>
      new AgBoolTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgBoolTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                labelText.hashCode),
            helperText.hashCode),
        initialValue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgBoolTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue))
        .toString();
  }
}

class AgBoolTemplateBuilder
    implements Builder<AgBoolTemplate, AgBoolTemplateBuilder> {
  _$AgBoolTemplate _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  bool _initialValue;
  bool get initialValue => _$this._initialValue;
  set initialValue(bool initialValue) => _$this._initialValue = initialValue;

  AgBoolTemplateBuilder();

  AgBoolTemplateBuilder get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgBoolTemplate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgBoolTemplate;
  }

  @override
  void update(void Function(AgBoolTemplateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgBoolTemplate build() {
    final _$result = _$v ??
        new _$AgBoolTemplate._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue);
    replace(_$result);
    return _$result;
  }
}

class _$AgIntTemplate extends AgIntTemplate {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final int initialValue;
  @override
  final int minLength;
  @override
  final int maxLength;

  factory _$AgIntTemplate([void Function(AgIntTemplateBuilder) updates]) =>
      (new AgIntTemplateBuilder()..update(updates)).build();

  _$AgIntTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue,
      this.minLength,
      this.maxLength})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'initialValue');
    }
    if (minLength == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'minLength');
    }
    if (maxLength == null) {
      throw new BuiltValueNullFieldError('AgIntTemplate', 'maxLength');
    }
  }

  @override
  AgIntTemplate rebuild(void Function(AgIntTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgIntTemplateBuilder toBuilder() => new AgIntTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgIntTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue &&
        minLength == other.minLength &&
        maxLength == other.maxLength;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                        labelText.hashCode),
                    helperText.hashCode),
                initialValue.hashCode),
            minLength.hashCode),
        maxLength.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgIntTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue)
          ..add('minLength', minLength)
          ..add('maxLength', maxLength))
        .toString();
  }
}

class AgIntTemplateBuilder
    implements Builder<AgIntTemplate, AgIntTemplateBuilder> {
  _$AgIntTemplate _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  int _initialValue;
  int get initialValue => _$this._initialValue;
  set initialValue(int initialValue) => _$this._initialValue = initialValue;

  int _minLength;
  int get minLength => _$this._minLength;
  set minLength(int minLength) => _$this._minLength = minLength;

  int _maxLength;
  int get maxLength => _$this._maxLength;
  set maxLength(int maxLength) => _$this._maxLength = maxLength;

  AgIntTemplateBuilder();

  AgIntTemplateBuilder get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _minLength = _$v.minLength;
      _maxLength = _$v.maxLength;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgIntTemplate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgIntTemplate;
  }

  @override
  void update(void Function(AgIntTemplateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgIntTemplate build() {
    final _$result = _$v ??
        new _$AgIntTemplate._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue,
            minLength: minLength,
            maxLength: maxLength);
    replace(_$result);
    return _$result;
  }
}

class _$AgDateRangeTemplate extends AgDateRangeTemplate {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final DateTimeRange initialValue;
  @override
  final DateTime min;
  @override
  final DateTime max;

  factory _$AgDateRangeTemplate(
          [void Function(AgDateRangeTemplateBuilder) updates]) =>
      (new AgDateRangeTemplateBuilder()..update(updates)).build();

  _$AgDateRangeTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue,
      this.min,
      this.max})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'initialValue');
    }
    if (min == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'min');
    }
    if (max == null) {
      throw new BuiltValueNullFieldError('AgDateRangeTemplate', 'max');
    }
  }

  @override
  AgDateRangeTemplate rebuild(
          void Function(AgDateRangeTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgDateRangeTemplateBuilder toBuilder() =>
      new AgDateRangeTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgDateRangeTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue &&
        min == other.min &&
        max == other.max;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                        labelText.hashCode),
                    helperText.hashCode),
                initialValue.hashCode),
            min.hashCode),
        max.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgDateRangeTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue)
          ..add('min', min)
          ..add('max', max))
        .toString();
  }
}

class AgDateRangeTemplateBuilder
    implements Builder<AgDateRangeTemplate, AgDateRangeTemplateBuilder> {
  _$AgDateRangeTemplate _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  DateTimeRange _initialValue;
  DateTimeRange get initialValue => _$this._initialValue;
  set initialValue(DateTimeRange initialValue) =>
      _$this._initialValue = initialValue;

  DateTime _min;
  DateTime get min => _$this._min;
  set min(DateTime min) => _$this._min = min;

  DateTime _max;
  DateTime get max => _$this._max;
  set max(DateTime max) => _$this._max = max;

  AgDateRangeTemplateBuilder();

  AgDateRangeTemplateBuilder get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _min = _$v.min;
      _max = _$v.max;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgDateRangeTemplate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgDateRangeTemplate;
  }

  @override
  void update(void Function(AgDateRangeTemplateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgDateRangeTemplate build() {
    final _$result = _$v ??
        new _$AgDateRangeTemplate._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue,
            min: min,
            max: max);
    replace(_$result);
    return _$result;
  }
}

class _$AgSecureTemplate extends AgSecureTemplate {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final String initialValue;
  @override
  final int minLength;
  @override
  final int maxLength;

  factory _$AgSecureTemplate(
          [void Function(AgSecureTemplateBuilder) updates]) =>
      (new AgSecureTemplateBuilder()..update(updates)).build();

  _$AgSecureTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue,
      this.minLength,
      this.maxLength})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'initialValue');
    }
    if (minLength == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'minLength');
    }
    if (maxLength == null) {
      throw new BuiltValueNullFieldError('AgSecureTemplate', 'maxLength');
    }
  }

  @override
  AgSecureTemplate rebuild(void Function(AgSecureTemplateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgSecureTemplateBuilder toBuilder() =>
      new AgSecureTemplateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgSecureTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue &&
        minLength == other.minLength &&
        maxLength == other.maxLength;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                        labelText.hashCode),
                    helperText.hashCode),
                initialValue.hashCode),
            minLength.hashCode),
        maxLength.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgSecureTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue)
          ..add('minLength', minLength)
          ..add('maxLength', maxLength))
        .toString();
  }
}

class AgSecureTemplateBuilder
    implements Builder<AgSecureTemplate, AgSecureTemplateBuilder> {
  _$AgSecureTemplate _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  String _initialValue;
  String get initialValue => _$this._initialValue;
  set initialValue(String initialValue) => _$this._initialValue = initialValue;

  int _minLength;
  int get minLength => _$this._minLength;
  set minLength(int minLength) => _$this._minLength = minLength;

  int _maxLength;
  int get maxLength => _$this._maxLength;
  set maxLength(int maxLength) => _$this._maxLength = maxLength;

  AgSecureTemplateBuilder();

  AgSecureTemplateBuilder get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _minLength = _$v.minLength;
      _maxLength = _$v.maxLength;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgSecureTemplate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgSecureTemplate;
  }

  @override
  void update(void Function(AgSecureTemplateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgSecureTemplate build() {
    final _$result = _$v ??
        new _$AgSecureTemplate._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue,
            minLength: minLength,
            maxLength: maxLength);
    replace(_$result);
    return _$result;
  }
}

class _$AgListTemplate<T> extends AgListTemplate<T> {
  @override
  final bool isRequired;
  @override
  final String hintText;
  @override
  final String labelText;
  @override
  final String helperText;
  @override
  final Iterable<T> initialValue;
  @override
  final Iterable<T> choices;

  factory _$AgListTemplate([void Function(AgListTemplateBuilder<T>) updates]) =>
      (new AgListTemplateBuilder<T>()..update(updates)).build();

  _$AgListTemplate._(
      {this.isRequired,
      this.hintText,
      this.labelText,
      this.helperText,
      this.initialValue,
      this.choices})
      : super._() {
    if (isRequired == null) {
      throw new BuiltValueNullFieldError('AgListTemplate', 'isRequired');
    }
    if (hintText == null) {
      throw new BuiltValueNullFieldError('AgListTemplate', 'hintText');
    }
    if (labelText == null) {
      throw new BuiltValueNullFieldError('AgListTemplate', 'labelText');
    }
    if (helperText == null) {
      throw new BuiltValueNullFieldError('AgListTemplate', 'helperText');
    }
    if (initialValue == null) {
      throw new BuiltValueNullFieldError('AgListTemplate', 'initialValue');
    }
    if (choices == null) {
      throw new BuiltValueNullFieldError('AgListTemplate', 'choices');
    }
    if (T == dynamic) {
      throw new BuiltValueMissingGenericsError('AgListTemplate', 'T');
    }
  }

  @override
  AgListTemplate<T> rebuild(void Function(AgListTemplateBuilder<T>) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AgListTemplateBuilder<T> toBuilder() =>
      new AgListTemplateBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AgListTemplate &&
        isRequired == other.isRequired &&
        hintText == other.hintText &&
        labelText == other.labelText &&
        helperText == other.helperText &&
        initialValue == other.initialValue &&
        choices == other.choices;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, isRequired.hashCode), hintText.hashCode),
                    labelText.hashCode),
                helperText.hashCode),
            initialValue.hashCode),
        choices.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AgListTemplate')
          ..add('isRequired', isRequired)
          ..add('hintText', hintText)
          ..add('labelText', labelText)
          ..add('helperText', helperText)
          ..add('initialValue', initialValue)
          ..add('choices', choices))
        .toString();
  }
}

class AgListTemplateBuilder<T>
    implements Builder<AgListTemplate<T>, AgListTemplateBuilder<T>> {
  _$AgListTemplate<T> _$v;

  bool _isRequired;
  bool get isRequired => _$this._isRequired;
  set isRequired(bool isRequired) => _$this._isRequired = isRequired;

  String _hintText;
  String get hintText => _$this._hintText;
  set hintText(String hintText) => _$this._hintText = hintText;

  String _labelText;
  String get labelText => _$this._labelText;
  set labelText(String labelText) => _$this._labelText = labelText;

  String _helperText;
  String get helperText => _$this._helperText;
  set helperText(String helperText) => _$this._helperText = helperText;

  Iterable<T> _initialValue;
  Iterable<T> get initialValue => _$this._initialValue;
  set initialValue(Iterable<T> initialValue) =>
      _$this._initialValue = initialValue;

  Iterable<T> _choices;
  Iterable<T> get choices => _$this._choices;
  set choices(Iterable<T> choices) => _$this._choices = choices;

  AgListTemplateBuilder();

  AgListTemplateBuilder<T> get _$this {
    if (_$v != null) {
      _isRequired = _$v.isRequired;
      _hintText = _$v.hintText;
      _labelText = _$v.labelText;
      _helperText = _$v.helperText;
      _initialValue = _$v.initialValue;
      _choices = _$v.choices;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AgListTemplate<T> other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AgListTemplate<T>;
  }

  @override
  void update(void Function(AgListTemplateBuilder<T>) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AgListTemplate<T> build() {
    final _$result = _$v ??
        new _$AgListTemplate<T>._(
            isRequired: isRequired,
            hintText: hintText,
            labelText: labelText,
            helperText: helperText,
            initialValue: initialValue,
            choices: choices);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
