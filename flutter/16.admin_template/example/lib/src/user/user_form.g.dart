// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_form.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

class _$UserForm extends UserForm {
  _$UserForm(this.model) : super._();

  final User model;

  @override
  Widget Function(BuildContext) get builder {
    return (BuildContext context) {
      return Container(
        alignment: Alignment.topLeft,
        width: 800,
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            // Pressing enter on the field will now move to the next field.
            LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
          },
          child: FocusTraversalGroup(
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    username,
                    const SizedBox(height: 24),
                    email,
                    const SizedBox(height: 24),
                    phone,
                    const SizedBox(height: 24),
                    bio,
                    const SizedBox(height: 24),
                    password,
                    const SizedBox(height: 24),
                    passwordConfirmation,
                    const SizedBox(height: 24),
                    acceptPromotionalEmail,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    };
  }

  @override
  FormField<String> get username {
    return AgTextField(
      labelText: 'username',
      onSaved: (newValue) {
        model.rebuild((b) => b.username = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (m) {
          return m.username;
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
        final validator = NameValidator<User>(propertyResolver: (m) {
          return m.email;
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
        final validator = NameValidator<User>(propertyResolver: (m) {
          return m.phone;
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
        final validator = NameValidator<User>(propertyResolver: (m) {
          return m.bio;
        });
        return validator.validate(model);
      },
    );
  }

  @override
  FormField<String> get password {
    return AgPasswordField(
      labelText: 'password',
      onSaved: (newValue) {
        model.rebuild((b) => b.password = newValue);
      },
    );
  }

  @override
  FormField<String> get passwordConfirmation {
    return AgPasswordField(
      labelText: 'passwordConfirmation',
      onSaved: (newValue) {
        model.rebuild((b) => b.passwordConfirmation = newValue);
      },
    );
  }

  @override
  FormField<bool> get acceptPromotionalEmail {
    return AgCheckboxField(
      initialValue: true,
      labelText: 'Is default site',
      helperText:
          'If true, this site will handle request for all other hostnames that do not have a site entry of their own.',
      onSaved: (newValue) {
        model.rebuild((b) => b.acceptPromotionalEmail = newValue);
      },
    );
  }
}
