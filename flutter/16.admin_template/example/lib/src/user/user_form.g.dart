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
                        groups,
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

  Widget get username {
    return AgTextField(
      initialValue: model.username,
      labelText: 'Username',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.username = newValue);
      },
      validator: RequiredValidator(property: 'username'),
    );
  }

  Widget get email {
    return AgTextField(
      hintText: 'Your business email address',
      initialValue: model.email,
      labelText: 'E-mail',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.email = newValue);
      },
      validator: CompositeValidator(property: 'email', validators: [
        RequiredValidator(property: 'email'),
        EmailValidator(property: 'email'),
      ]),
    );
  }

  Widget get phone {
    return AgTextField(
      initialValue: model.phone,
      labelText: 'Phone',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.phone = newValue);
      },
    );
  }

  Widget get bio {
    return AgTextField(
      helperText: 'Keep it short, this is just a demo.',
      hintText:
          'Tell us about yourself (e.g., write down what you do or what hobbies you have)',
      initialValue: model.bio,
      labelText: 'Life story',
      maxLength: 200,
      onSaved: (newValue) {
        model = model.rebuild((b) => b.bio = newValue);
      },
    );
  }

  Widget get password {
    return AgPasswordField(
      helperText: 'Must have at least 8 characters.',
      initialValue: model.password,
      labelText: 'Password',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.password = newValue);
      },
      validator: CompositeValidator(property: 'password', validators: [
        RequiredValidator(property: 'password'),
        MinLengthValidator(8, property: 'password'),
      ]),
    );
  }

  Widget get passwordConfirmation {
    return AgPasswordField(
      initialValue: model.passwordConfirmation,
      labelText: 'Password Confirmation',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.passwordConfirmation = newValue);
      },
    );
  }

  Widget get acceptPromotionalEmail {
    return AgCheckboxField(
      helperText: 'I would like to receive the weekly email about new deals.',
      initialValue: model.acceptPromotionalEmail ?? true,
      labelText: 'Opt-in hot deals',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.acceptPromotionalEmail = newValue);
      },
    );
  }

  Widget get groups {
    return AgCheckboxListField(
      helperText: 'The groups this user belongs to.',
      initialValue: model.groups,
      labelText: 'Groups',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.groups = ListBuilder(newValue));
      },
      validator: RequiredValidator(property: 'groups'),
      choices: const [
        'moderator',
        'editor',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
