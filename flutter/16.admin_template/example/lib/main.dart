import 'dart:async';

import 'package:admin_template/admin_template.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.teal),
    home: _Demo(),
  ));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HorizontalSplitter(initialLayoutMask: '0.2, 0.8', children: [
        Theme(
          data: greyTheme.copyWith(visualDensity: VisualDensity.compact),
          child: Builder(builder: (context) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: ListView(physics: ClampingScrollPhysics(), children: [
                ListTile(leading: Icon(Icons.folder), title: Text('Pages')),
                ListTile(leading: Icon(Icons.email), title: Text('Inbox')),
              ]),
            );
          }),
        ),
        VerticalSplitter(initialLayoutMask: '0.1, 0.9', children: [
          Container(color: Theme.of(context).primaryColor),
          FormDemo(),
        ]),
      ]),
    );
  }
}

class FormDemo extends StatefulWidget {
  const FormDemo({Key key}) : super(key: key);

  @override
  FormDemoState createState() => FormDemoState();
}

class PersonData {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
}

class FormDemoState extends State<FormDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  bool _autovalidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      _UsNumberTextInputFormatter();
  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar("${person.name}'s phone number is ${person.phoneNumber}");
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePhoneNumber(String value) {
    _formWasEdited = true;
    final RegExp phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value))
      return '(###) ###-#### - Enter a US phone number.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value) return "The passwords don't match";
    return null;
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate()) return true;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('This form has errors'),
              content: const Text('Really leave this form?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      onWillPop: _warnUserAboutInvalidData,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AgTextField(
                icon: Icon(Icons.person),
                hintText: 'What do people call you?',
                labelText: 'Name *',
                onSaved: (String value) {
                  person.name = value;
                },
                validator: _validateName,
              ),
              const SizedBox(height: 24.0),
              AgTextField(
                icon: Icon(Icons.phone),
                hintText: 'Where can we reach you?',
                prefixText: '+1',
                labelText: 'Phone',
              ),
              const SizedBox(height: 24.0),
              AgTextField(
                icon: Icon(Icons.email),
                hintText: 'Your email address',
                labelText: 'E-mail',
                onSaved: (String value) {
                  person.email = value;
                },
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      'Tell us about yourself (e.g., write down what you do or what hobbies you have)',
                  helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Life story',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  labelText: 'Net Worth',
                  prefixText: r'$',
                  suffixText: 'USD',
                  suffixStyle: TextStyle(color: Colors.green),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24.0),
              AgPasswordField(
                fieldKey: _passwordFieldKey,
                helperText: 'No more than 8 characters.',
                labelText: 'Password *',
                onFieldSubmitted: (String value) {
                  setState(() {
                    person.password = value;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              AgPasswordField(
                labelText: 'Re-type password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
