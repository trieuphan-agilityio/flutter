import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';

import 'user.dart';

part 'user_form.g.dart';

abstract class AgForm<T> {
  T get model;
}

abstract class UserForm implements AgForm<User> {
  factory UserForm.editing({User model}) = _$UserEditingForm;
}
