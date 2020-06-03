import 'package:admin_template/admin_template.dart';
import 'package:built_collection/built_collection.dart';
import 'package:example/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'user.dart';

part 'user_form.g.dart';

@AgForm(modelType: User)
abstract class UserForm {
  /// The widget to mount this form to the Widget tree
  FormBuilder<User> get builder;

  factory UserForm.edit(User model) => _$UserForm(model);

  UserForm._();
}
