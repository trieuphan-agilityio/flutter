// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_form.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

class _$EditUserForm extends UserForm {
  @override
  FormField<String> get username {
    return AgTextField(
      labelText: 'username',
      onSaved: (newValue) {
        model.rebuild((b) => b.username = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.username;
        });
        return validator.validate(model);
      },
    );
  }

  @override
  FormField<String> get email {
    return AgTextField(
      labelText: 'email',
      onSaved: (newValue) {
        model.rebuild((b) => b.email = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.email;
        });
        return validator.validate(model);
      },
    );
  }

  @override
  FormField<String> get phone {
    return AgTextField(
      labelText: 'phone',
      onSaved: (newValue) {
        model.rebuild((b) => b.phone = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.phone;
        });
        return validator.validate(model);
      },
    );
  }

  @override
  FormField<String> get bio {
    return AgTextField(
      labelText: 'bio',
      onSaved: (newValue) {
        model.rebuild((b) => b.bio = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.bio;
        });
        return validator.validate(model);
      },
    );
  }

  @override
  FormField<String> get password {
    return AgTextField(
      labelText: 'password',
      onSaved: (newValue) {
        model.rebuild((b) => b.password = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.password;
        });
        return validator.validate(model);
      },
    );
  }

  @override
  FormField<String> get passwordConfirmation {
    return AgTextField(
      labelText: 'passwordConfirmation',
      onSaved: (newValue) {
        model.rebuild((b) => b.passwordConfirmation = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.passwordConfirmation;
        });
        return validator.validate(model);
      },
    );
  }
}
