part of 'user_add_form.dart';

class _$UserAddForm extends StatefulWidget {
  @override
  __$UserAddFormState createState() => __$UserAddFormState();
}

class __$UserAddFormState extends State<_$UserAddForm> {
  dynamic model;

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildUsername(),
          _buildGroups(),
        ],
      ),
    );
  }

  Widget _buildUsername() {
    return AgTextField(
      initialValue: model.username,
      labelText: 'Username',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.username = newValue);
      },
    );
  }

  Widget _buildGroups() {
    return AgCheckboxListField(
      helperText: 'The groups this user belongs to.',
      initialValue: model.groups,
      labelText: 'Groups',
      onSaved: (newValue) {
        model = model.rebuild((b) => b.groups = ListBuilder(newValue));
      },
      choices: const [
        'moderator',
        'editor',
      ],
    );
  }
}

// ignore: unused_element
final _tmp = _UserAddForm();
