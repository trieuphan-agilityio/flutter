// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_form.dart';

// **************************************************************************
// AgFormGenerator
// **************************************************************************

class _$UserEditingForm implements UserForm {
  final User _model;

  _$UserEditingForm({User model}) : _model = model;

  @override
  User get model => _model;

  Widget build(BuildContext context) {
    return Form(
      child: Column(children: [
        AgTextField(
          onSaved: (newValue) {
            model.rebuild((b) => b.username = newValue);
          },
          validator: (value) {
            final validator = NameValidator<User>(propertyResolver: (user) {
              return user.username;
            });
            return validator.validate(model);
          },
        ),
        AgTextField(
          hintText: 'Your email address',
          labelText: 'E-mail',
          onSaved: (newValue) {
            model.rebuild((b) => b.email = newValue);
          },
          validator: (value) {
            final validator = EmailValidator<User>(propertyResolver: (user) {
              return user.email;
            });
            return validator.validate(model);
          },
        ),
        AgTextField(
          onSaved: (newValue) {
            model.rebuild((b) => b.phone = newValue);
          },
          validator: (value) {
            final validator = EmailValidator<User>(propertyResolver: (user) {
              return user.email;
            });
            return validator.validate(model);
          },
        ),
        AgPasswordField(onSaved: (newValue) {
          model.rebuild((b) => b.password = newValue);
        }),
        AgPasswordField(validator: (value) {
          if (model.password == model.passwordConfirmation) return null;
          return 'Password Confirmation does not match';
        }),
        AgTextField(
          onSaved: (newValue) {
            model.rebuild((b) => b.email = newValue);
          },
        ),
      ]),
    );
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
