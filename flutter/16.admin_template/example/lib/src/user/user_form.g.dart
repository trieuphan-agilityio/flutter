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

  FormField<String> get username {
    return AgTextField(
      labelText: "Username",
      onSaved: (newValue) {
        model.rebuild((b) => b.username = newValue);
      },
    );
  }

  FormField<String> get email {
    return AgTextField(
      hintText: "Your email address",
      labelText: "E-mail",
      onSaved: (newValue) {
        model.rebuild((b) => b.email = newValue);
      },
    );
  }

  FormField<String> get phone {
    return AgTextField(
      labelText: "Phone",
      onSaved: (newValue) {
        model.rebuild((b) => b.phone = newValue);
      },
    );
  }

  FormField<String> get bio {
    return AgTextField(
      hintText:
          "Tell us about yourself (e.g., write down what you do or what hobbies you have)",
      helperText: "Keep it short, this is just a demo.",
      labelText: "Life story",
      onSaved: (newValue) {
        model.rebuild((b) => b.bio = newValue);
      },
    );
  }

  FormField<String> get password {
    return AgPasswordField(
      helperText: "Must have at least 8 characters.",
      labelText: "Password",
      onSaved: (newValue) {
        model.rebuild((b) => b.password = newValue);
      },
    );
  }

  FormField<String> get passwordConfirmation {
    return AgPasswordField(
      labelText: "Password Confirmation",
      onSaved: (newValue) {
        model.rebuild((b) => b.passwordConfirmation = newValue);
      },
    );
  }

  FormField<bool> get acceptPromotionalEmail {
    return AgCheckboxField(
      helperText: "I'd like to receive the weekly email about new deals.",
      labelText: "Opt-in hot deals",
      initialValue: true,
      onSaved: (newValue) {
        model.rebuild((b) => b.acceptPromotionalEmail = newValue);
      },
    );
  }
}
