part of '_form_generator_test_input.dart';

@ShouldGenerate(r'''
class _$LoginForm extends StatefulWidget {
  const _$LoginForm(
      {Key key,
      this.initialModel,
      this.onWillPop,
      this.onChanged,
      this.onSaved,
      this.email,
      this.password})
      : super(key: key);

  final LoginModel initialModel;

  final WillPopCallback onWillPop;

  final VoidCallback onChanged;

  final ValueChanged onSaved;

  final Widget email;

  final Widget password;

  @override
  __$LoginForm createState() => __$LoginForm();
}

class __$LoginForm extends State<_$LoginForm> {
  LoginModel model;

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
                  widget.email ?? _buildEmail(),
                  widget.password ?? _buildPassword(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return AgTextField(
        validator: const RequiredValidator(property: 'email'),
        labelText: 'E-mail',
        initialValue: model.email,
        onSaved: (newValue) {
          model = model.copyWith(email: newValue);
        });
  }

  Widget _buildPassword() {
    return AgTextField(
        validator: const RequiredValidator(property: 'password'),
        hintText: 'To continue, first verify that it is you',
        labelText: 'Enter your password',
        initialValue: model.password,
        onSaved: (newValue) {
          model = model.copyWith(password: newValue);
        });
  }
}

// ignore: unused_element
final _tmp = _LoginForm();
''')
@AgForm(modelType: LoginModel)
class _LoginForm {
  AgFieldTemplate<String> get email => AgFieldTemplate((b) => b
    ..isRequired = true
    ..labelText = 'E-mail');

  AgTextTemplate get password => AgTextTemplate((b) => b
    ..isRequired = true
    ..hintText = 'To continue, first verify that it is you'
    ..labelText = 'Enter your password');
}

class LoginModel {
  final String email;
  final String password;

  const LoginModel({this.email, this.password});

  LoginModel copyWith({String email, String password}) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
