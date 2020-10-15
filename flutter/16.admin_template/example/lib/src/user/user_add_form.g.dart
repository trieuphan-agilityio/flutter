part of 'user_add_form.dart';

class _$UserAddForm extends StatefulWidget implements AddForm<UserAddModel> {
  final UserAddModel initialModel;
  final Widget username;
  final Widget email;
  final Widget phone;
  final Widget bio;
  final Widget password;
  final Widget passwordConfirmation;
  final Widget acceptActivityEmail;
  final Widget groups;

  const _$UserAddForm(
      {Key key,
      this.initialModel,
      this.username,
      this.email,
      this.phone,
      this.bio,
      this.password,
      this.passwordConfirmation,
      this.acceptActivityEmail,
      this.groups})
      : super(key: key);

  @override
  __$UserAddFormState createState() => __$UserAddFormState();
}

class __$UserAddFormState extends State<_$UserAddForm> {
  UserAddModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          widget.username ?? _buildUsername(),
          widget.email ?? _buildEmail(),
          widget.phone ?? _buildPhone(),
          widget.bio ?? _buildBio(),
          widget.password ?? _buildPassword(),
          widget.passwordConfirmation ?? _buildPasswordConfirmation(),
          widget.acceptActivityEmail ?? _buildAcceptActivityEmail(),
          widget.groups ?? _buildGroups(),
        ],
      ),
    );
  }

  Widget _buildUsername() {
    return AgTextField(
      initialValue: model.username,
      labelText: 'Username',
      onSaved: (newValue) => model = model.copyWith(
        username: newValue,
      ),
    );
  }

  // FIXME
  Widget _buildEmail() => SizedBox.shrink();
  Widget _buildPhone() => SizedBox.shrink();
  Widget _buildBio() => SizedBox.shrink();
  Widget _buildPassword() => SizedBox.shrink();
  Widget _buildPasswordConfirmation() => SizedBox.shrink();
  Widget _buildAcceptActivityEmail() => SizedBox.shrink();

  Widget _buildGroups() {
    return AgCheckboxListField<UserRole>(
      initialValue: model.groups,
      choices: UserRole.values,
      stringify: (UserRole value) => value.name,
      helperText: 'The groups this user belongs to.',
      labelText: 'Groups',
      onSaved: (Iterable<UserRole> newValue) => model = model.copyWith(
        groups: newValue,
      ),
    );
  }
}

// ignore: unused_element
final _tmp = _UserAddForm();
