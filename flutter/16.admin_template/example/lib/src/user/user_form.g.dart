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
  FormField<String> get builder {
    return AgTextField(
      labelText: 'builder',
      onSaved: (newValue) {
        model.rebuild((b) => b.builder = newValue);
      },
      validator: (value) {
        final validator = NameValidator<User>(propertyResolver: (user) {
          return user.builder;
        });
        return validator.validate(model);
      },
    );
  }
}
