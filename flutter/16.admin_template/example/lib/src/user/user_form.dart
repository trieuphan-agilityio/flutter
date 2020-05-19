import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'user.dart';

part 'user_form.g.dart';

@agEditForm
abstract class UserForm implements AgForm<User> {
  static UserForm editing(User model) => _$EditUserForm(model);

  FormField<String> get username;
  FormField<String> get email;
  FormField<String> get phone;
  FormField<String> get bio;
  FormField<String> get password;
  FormField<String> get passwordConfirmation;
}
