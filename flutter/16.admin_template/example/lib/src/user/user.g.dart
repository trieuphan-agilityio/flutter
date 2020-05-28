// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserRole _$moderator = const UserRole._('moderator');
const UserRole _$editor = const UserRole._('editor');

UserRole _$urValueOf(String name) {
  switch (name) {
    case 'moderator':
      return _$moderator;
    case 'editor':
      return _$editor;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UserRole> _$urValues = new BuiltSet<UserRole>(const <UserRole>[
  _$moderator,
  _$editor,
]);

class _$User extends User {
  @override
  final String username;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String bio;
  @override
  final String password;
  @override
  final String passwordConfirmation;
  @override
  final bool acceptPromotionalEmail;
  @override
  final List<UserRole> groups;

  factory _$User([void Function(UserBuilder) updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
      {this.username,
      this.email,
      this.phone,
      this.bio,
      this.password,
      this.passwordConfirmation,
      this.acceptPromotionalEmail,
      this.groups})
      : super._() {
    if (username == null) {
      throw new BuiltValueNullFieldError('User', 'username');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('User', 'email');
    }
    if (password == null) {
      throw new BuiltValueNullFieldError('User', 'password');
    }
    if (passwordConfirmation == null) {
      throw new BuiltValueNullFieldError('User', 'passwordConfirmation');
    }
    if (acceptPromotionalEmail == null) {
      throw new BuiltValueNullFieldError('User', 'acceptPromotionalEmail');
    }
    if (groups == null) {
      throw new BuiltValueNullFieldError('User', 'groups');
    }
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        username == other.username &&
        email == other.email &&
        phone == other.phone &&
        bio == other.bio &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation &&
        acceptPromotionalEmail == other.acceptPromotionalEmail &&
        groups == other.groups;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, username.hashCode), email.hashCode),
                            phone.hashCode),
                        bio.hashCode),
                    password.hashCode),
                passwordConfirmation.hashCode),
            acceptPromotionalEmail.hashCode),
        groups.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('username', username)
          ..add('email', email)
          ..add('phone', phone)
          ..add('bio', bio)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation)
          ..add('acceptPromotionalEmail', acceptPromotionalEmail)
          ..add('groups', groups))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  String _bio;
  String get bio => _$this._bio;
  set bio(String bio) => _$this._bio = bio;

  String _password;
  String get password => _$this._password;
  set password(String password) => _$this._password = password;

  String _passwordConfirmation;
  String get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  bool _acceptPromotionalEmail;
  bool get acceptPromotionalEmail => _$this._acceptPromotionalEmail;
  set acceptPromotionalEmail(bool acceptPromotionalEmail) =>
      _$this._acceptPromotionalEmail = acceptPromotionalEmail;

  List<UserRole> _groups;
  List<UserRole> get groups => _$this._groups;
  set groups(List<UserRole> groups) => _$this._groups = groups;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _username = _$v.username;
      _email = _$v.email;
      _phone = _$v.phone;
      _bio = _$v.bio;
      _password = _$v.password;
      _passwordConfirmation = _$v.passwordConfirmation;
      _acceptPromotionalEmail = _$v.acceptPromotionalEmail;
      _groups = _$v.groups;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    final _$result = _$v ??
        new _$User._(
            username: username,
            email: email,
            phone: phone,
            bio: bio,
            password: password,
            passwordConfirmation: passwordConfirmation,
            acceptPromotionalEmail: acceptPromotionalEmail,
            groups: groups);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
