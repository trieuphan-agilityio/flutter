import 'package:admin_template/admin_template.dart';
import 'package:admin_template_core/form.dart';
import 'package:flutter/widgets.dart';

part 'user_add_form.g.dart';

class UserAddForm extends _$UserAddForm {
  final UserAddModel initialModel;

  UserAddForm({Key key, @required this.initialModel})
      : super(
          key: key,
          initialModel: initialModel,
          acceptActivityEmail: AgCheckboxField(initialValue: true),
        );
}

class _UserAddForm implements AddForm<UserAddModel> {
  AgFieldTemplate<String> get usernameTemplate =>
      AgFieldTemplate((b) => b..isRequired = true);

  AgTextTemplate get emailTemplate => AgTextTemplate((b) => b
    ..isRequired = true
    ..hintText = 'Your business email address'
    ..labelText = 'E-mail');

  AgTextTemplate get bioTemplate => AgTextTemplate((b) => b
    ..maxLength = 150
    ..hintText = 'Tell us about yourself'
        ' (e.g., write down what you do or what hobbies you have)'
    ..helperText = 'Keep it short, this is just a demo.'
    ..labelText = 'Life story');

  AgSecureTemplate get passwordTemplate =>
      AgSecureTemplate((b) => b..isRequired = true);

  AgSecureTemplate get passwordConfirmationTemplate =>
      AgSecureTemplate((b) => b..isRequired = true);

  AgBoolTemplate get acceptActivityEmailTemplate =>
      AgBoolTemplate((b) => b..isRequired = true);

  AgListTemplate<UserRole> get groupsTemplate => AgListTemplate((b) => b
    ..isRequired = true
    ..initialValue = const [UserRole.editor]
    ..choices = UserRole.values
    ..helperText = 'The groups this user belongs to.'
    ..stringify = (UserRole value) => value.name);
}

// -----------------------------------------------------------------------------
// Models
// -----------------------------------------------------------------------------

class UserRole {
  static const UserRole moderator = _$moderator;
  static const UserRole editor = _$editor;

  final String name;
  const UserRole._(this.name);

  @override
  String toString() => name;

  static Iterable<UserRole> get values => _$urValues;
  static UserRole valueOf(String name) => _$urValueOf(name);
}

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

final Iterable<UserRole> _$urValues = const <UserRole>[_$moderator, _$editor];

class UserAddModel {
  final String username;
  final String email;
  final String phone;
  final String bio;
  final String password;
  final String passwordConfirmation;
  final bool acceptActivityEmail;
  final Iterable<UserRole> groups;

  UserAddModel({
    this.username,
    this.email,
    this.phone,
    this.bio,
    this.password,
    this.passwordConfirmation,
    this.acceptActivityEmail,
    this.groups,
  });

  UserAddModel copyWith({
    String username,
    String email,
    String phone,
    String bio,
    String password,
    String passwordConfirmation,
    bool acceptActivityEmail,
    Iterable<UserRole> groups,
  }) {
    return UserAddModel(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      acceptActivityEmail: acceptActivityEmail ?? this.acceptActivityEmail,
      groups: groups ?? this.groups,
    );
  }
}
