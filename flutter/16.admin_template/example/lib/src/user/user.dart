import 'package:admin_template/admin_template.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'user.g.dart';

/// ===================================================================
/// User Role
/// ===================================================================

const List<String> _kGroupChoices = ['moderator', 'editor'];

class UserRole extends EnumClass {
  static const UserRole moderator = _$moderator;
  static const UserRole editor = _$editor;

  const UserRole._(String name) : super(name);

  static BuiltSet<UserRole> get values => _$urValues;
  static UserRole valueOf(String name) => _$urValueOf(name);
}

/// ===================================================================
/// User
/// ===================================================================

abstract class User implements Built<User, UserBuilder> {
  @AgText(isRequired: true)
  String get username;

  @AgEmail(
    isRequired: true,
    hintText: 'Your business email address',
    labelText: 'E-mail',
  )
  String get email;

  //@AgMask(pattern: '(###) ###-###')
  @AgText()
  @nullable
  String get phone;

  @AgText(
    maxLength: 150,
    hintText: 'Tell us about yourself'
        ' (e.g., write down what you do or what hobbies you have)',
    helperText: 'Keep it short, this is just a demo.',
    labelText: 'Life story',
  )
  @nullable
  String get bio;

  @AgPassword(
    isRequired: true,
    minLength: 8,
    helperText: 'Must have at least 8 characters.',
    labelText: 'Password',
  )
  String get password;

  //@AgMatch(otherProperty: 'password')
  @AgPassword()
  String get passwordConfirmation;

  @AgBool(
    initialValue: true,
    helperText: 'I would like to receive the weekly email about new deals.',
    labelText: 'Opt-in hot deals',
  )
  bool get acceptPromotionalEmail;

  @AgList(
    isRequired: true,
    choices: _kGroupChoices,
    helperText: 'The groups this user belongs to.',
  )
  BuiltList<String> get groups;

  factory User([void Function(UserBuilder) updates]) = _$User;
  User._();
}
