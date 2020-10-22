// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_add_form.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

class _$UserAddForm extends StatefulWidget {
  const _$UserAddForm(
      {Key key,
      this.initialModel,
      this.onWillPop,
      this.onChanged,
      this.onSaved,
      this.username,
      this.email,
      this.bio,
      this.password,
      this.passwordConfirmation,
      this.acceptActivityEmail,
      this.groups})
      : super(key: key);

  final UserAddModel initialModel;

  final WillPopCallback onWillPop;

  final VoidCallback onChanged;

  final ValueChanged onSaved;

  final Widget username;

  final Widget email;

  final Widget bio;

  final Widget password;

  final Widget passwordConfirmation;

  final Widget acceptActivityEmail;

  final Widget groups;

  @override
  __$UserAddForm createState() => __$UserAddForm();
}

class __$UserAddForm extends State<_$UserAddForm> {
  UserAddModel model;

  @override
  void initState() {
    model = widget.initialModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // Pressing enter on the field will now move to the next field.
        LogicalKeySet(LogicalKeyboardKey.enter): NextFocusIntent(),
      },
      child: FocusTraversalGroup(
        child: Form(
          onWillPop: widget.onWillPop,
          onChanged: widget.onChanged,
          child: Builder(builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  widget.username ?? _buildUsername(),
                  widget.email ?? _buildEmail(),
                  widget.bio ?? _buildBio(),
                  widget.password ?? _buildPassword(),
                  widget.passwordConfirmation ?? _buildPasswordConfirmation(),
                  widget.acceptActivityEmail ?? _buildAcceptActivityEmail(),
                  widget.groups ?? _buildGroups(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildUsername() {
    return AgTextField(
        validator: const RequiredValidator(property: 'username'),
        initialValue: model.username,
        onSaved: (newValue) {
          model = model.copyWith(username: newValue);
        });
  }

  Widget _buildEmail() {
    return AgTextField(
        validator: const RequiredValidator(property: 'email'),
        hintText: 'Your business email address',
        labelText: 'E-mail',
        initialValue: model.email,
        onSaved: (newValue) {
          model = model.copyWith(email: newValue);
        });
  }

  Widget _buildBio() {
    return AgTextField(
        maxLength: 150,
        hintText: 'Tell us about yourself'
            ' (e.g., write down what you do or what hobbies you have)',
        helperText: 'Keep it short, this is just a demo.',
        labelText: 'Life story',
        initialValue: model.bio,
        onSaved: (newValue) {
          model = model.copyWith(bio: newValue);
        });
  }

  Widget _buildPassword() {
    return AgTextField(
        validator: const RequiredValidator(property: 'password'),
        initialValue: model.password,
        onSaved: (newValue) {
          model = model.copyWith(password: newValue);
        });
  }

  Widget _buildPasswordConfirmation() {
    return AgTextField(
        validator: const RequiredValidator(property: 'passwordConfirmation'),
        initialValue: model.passwordConfirmation,
        onSaved: (newValue) {
          model = model.copyWith(passwordConfirmation: newValue);
        });
  }

  Widget _buildAcceptActivityEmail() {
    return AgCheckboxField(
        validator: const RequiredValidator(property: 'acceptActivityEmail'),
        initialValue: model.acceptActivityEmail,
        onSaved: (newValue) {
          model = model.copyWith(acceptActivityEmail: newValue);
        });
  }

  Widget _buildGroups() {
    return AgCheckboxListField(
        validator: const RequiredValidator(property: 'groups'),
        initialValue: const [UserRole.editor],
        choices: UserRole.values,
        helperText: 'The groups this user belongs to.',
        stringify: (UserRole value) => value.name,
        onSaved: (newValue) {
          model = model.copyWith(groups: newValue);
        });
  }
}

// ignore: unused_element
final _tmp = _UserAddForm();
