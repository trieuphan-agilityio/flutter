import 'package:admin_template/admin_template.dart';
import 'package:built_value/built_value.dart';

part 'user.g.dart';

enum UserRole { moderator, editor }

abstract class User implements Built<User, UserBuilder> {
  User._();

  @agRequired
  @agName
  String get username;

//  @AgCharField(
//    hintText: 'Your email address',
//    labelText: 'E-mail',
//  )
  String get email;

  @AgMask(pattern: '(###) ###-###')
  String get phone;

  @agRequired
  @agPassword
  @AgMax(30)
//  @AgCharField(
//    helperText: 'No more than 8 characters.',
//    labelText: 'Password *',
//    validators: [],
//  )
  String get password;

  @AgMatch(otherProperty: 'password')
  @AgMax(30)
  String get passwordConfirmation;

  @agRequired
  List<UserRole> get groups;

  factory User([void Function(UserBuilder) updates]) = _$User;
}
