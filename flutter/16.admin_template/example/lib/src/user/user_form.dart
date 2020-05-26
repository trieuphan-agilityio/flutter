import 'package:admin_template/admin_template.dart';
import 'package:example/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'user.dart';

part 'user_form.g.dart';

typedef FormBuilder = Widget Function(
  BuildContext context, {
  bool autovalidate,
  WillPopCallback onWillPop,
  VoidCallback onChanged,
  ValueChanged<User> onSaved,
});

@AgForm(modelType: User)
abstract class UserForm {
  /// The widget to mount this form to the Widget tree
  FormBuilder get builder;

  factory UserForm.edit(User model) => _$UserForm(model);

  UserForm._();
}
