import 'package:test/test.dart';

import 'util.dart';

main() {
  useDartfmt();

  group('generator', () {
    test('run with 2 text fields', () async {
      final actual = await generate('''library form;
import 'package:test_support/test_support.dart';

part 'form.g.dart';

class LoginForm extends _\$LoginForm {
  final LoginModel initialModel;

  LoginForm({Key key, @required this.initialModel})
      : super(
          key: key,
          initialModel: initialModel,
        );
}

abstract class _LoginForm implements AddForm<LoginModel> {
  AgFieldTemplate<String> get emailTemplate => AgFieldTemplate((b) => b
    ..isRequired = true
    ..labelText = 'E-mail');

  AgTextTemplate get passwordTemplate => AgTextTemplate((b) => b
    ..isRequired = true
    ..hintText = 'To continue, first verify that it is you'
    ..labelText = 'Enter your password');
}

class LoginModel {
  final String email;
  final String password;

  LoginModel({this.email, this.password});

  LoginModel copyWith({String email, String password}) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
      ''');

      final expected = '''
part of 'form.dart';

class _\$LoginForm extends StatefulWidget {
  final LoginModel initialModel;
  final Widget email;
  final Widget password;

  const _\$LoginForm(
      {Key key,
      this.initialModel,
      this.email,
      this.password})
      : super(key: key);

  @override
  __\$LoginForm createState() => __\$LoginForm();
}

class __\$LoginForm extends State<_\$LoginForm> {
  LoginModel model;

  @override
  void initState() {
    model = widget.initialModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          widget.email ?? _buildEmail(),
          widget.password ?? _buildPassword(),
        ],
      ),
    );
  }

  Widget _buildEmail() {
    return AgTextField(
      initialValue: model.email,
      isRequired: true,
      labelText: 'E-mail',
      onSaved: (newValue) => model = model.copyWith(
        email: newValue,
      ),
    );
  }


  Widget _buildPassword() {
    return AgTextField(
      initialValue: model.password,
      isRequired: true,
      hintText: 'To continue, first verify that it is you',
      labelText: 'Enter your password',
      onSaved: (newValue) => model = model.copyWith(
        password: newValue,
      ),
    );
  }
}

// ignore: unused_element
final _tmp = _LoginForm();
      ''';
      expect(actual, contains(expected));
    }, timeout: Timeout.none);
  });
}
