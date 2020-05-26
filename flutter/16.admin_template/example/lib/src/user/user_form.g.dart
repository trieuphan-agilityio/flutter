// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_form.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

class _$UserForm extends UserForm {
  _$UserForm(this.model) : super._();

  User model;

  @override
  FormBuilder get builder {
    return (
      BuildContext context, {
      bool autovalidate = false,
      WillPopCallback onWillPop,
      VoidCallback onChanged,
      ValueChanged<User> onSaved,
    }) {
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
              autovalidate: autovalidate,
              onWillPop: onWillPop,
              onChanged: onChanged,
              child: Builder(
                builder: (BuildContext fContext) {
                  return SingleChildScrollView(
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
                        const SizedBox(height: 24),
                        Row(children: [
                          RaisedButton(
                            color: Theme.of(context).buttonColor,
                            child: Text('Save'),
                            onPressed: () {
                              final formState = Form.of(fContext);
                              if (formState.validate()) {
                                Form.of(fContext).save();
                                onSaved(model);
                              }
                            },
                          ),
                          RaisedButton(
                            child: Text('Reset'),
                            onPressed: () {
                              Form.of(fContext).reset();
                            },
                          ),
                          RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              print('Cancel');
                            },
                          ),
                        ]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    };
  }

  FormField<String> get username {
    return AgTextField(
      initialValue: model.username,
      labelText: "Username",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.username = newValue);
      },
    );
  }

  FormField<String> get email {
    return AgTextField(
      initialValue: model.email,
      hintText: "Your business email address",
      labelText: "E-mail",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.email = newValue);
      },
    );
  }

  FormField<String> get phone {
    return AgTextField(
      initialValue: model.phone,
      labelText: "Phone",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.phone = newValue);
      },
    );
  }

  FormField<String> get bio {
    return AgTextField(
      initialValue: model.bio,
      hintText:
          "Tell us about yourself (e.g., write down what you do or what hobbies you have)",
      helperText: "Keep it short, this is just a demo.",
      labelText: "Life story",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.bio = newValue);
      },
    );
  }

  FormField<String> get password {
    return AgPasswordField(
      initialValue: model.password,
      helperText: "Must have at least 8 characters.",
      labelText: "Password",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.password = newValue);
      },
    );
  }

  FormField<String> get passwordConfirmation {
    return AgPasswordField(
      initialValue: model.passwordConfirmation,
      labelText: "Password Confirmation",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.passwordConfirmation = newValue);
      },
    );
  }

  FormField<bool> get acceptPromotionalEmail {
    return AgCheckboxField(
      initialValue: model.acceptPromotionalEmail ?? true,
      helperText: "I'd like to receive the weekly email about new deals.",
      labelText: "Opt-in hot deals",
      onSaved: (newValue) {
        model = model.rebuild((b) => b.acceptPromotionalEmail = newValue);
      },
    );
  }
}
