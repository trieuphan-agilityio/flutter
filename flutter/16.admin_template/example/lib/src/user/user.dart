import 'package:admin_template/admin_template.dart';
import 'package:built_value/built_value.dart';

part 'user.g.dart';

enum UserRole { moderator, editor }

abstract class User implements Built<User, UserBuilder> {
  @AgText(required: true)
  String get username;

  @AgText(
    required: true,
    hintText: 'Your email address',
    labelText: 'E-mail',
  )
  String get email;

  //@AgMask(pattern: '(###) ###-###')
  @AgText()
  String get phone;

  @AgText(
    maxLength: 200,
    hintText: 'Tell us about yourself'
        ' (e.g., write down what you do or what hobbies you have)',
    helperText: 'Keep it short, this is just a demo.',
    labelText: 'Life story',
  )
  @nullable
  String get bio;

  @AgPassword(
    required: true,
    minLength: 8,
    helperText: 'Must have at least 8 characters.',
    labelText: 'Password',
  )
  String get password;

  //@AgMatch(otherProperty: 'password')
  @AgPassword(required: true)
  String get passwordConfirmation;

  @AgBool(
    initialValue: true,
    helperText: 'I\'d like to receive the weekly email about new deals.',
    labelText: 'Opt-in hot deals',
  )
  bool get acceptPromotionalEmail;

  //@AgRelated(required: true)
  List<UserRole> get groups;

  factory User([void Function(UserBuilder) updates]) = _$User;
  User._();
}
