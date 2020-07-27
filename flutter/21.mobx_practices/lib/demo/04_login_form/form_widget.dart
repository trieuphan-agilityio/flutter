import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_practices/demo/04_login_form/form_store.dart';

class FormWidget extends StatefulWidget {
  const FormWidget();

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final FormStore store = FormStore();

  @override
  void initState() {
    super.initState();
    store.setupValidations();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Observer(
                builder: (_) => TextField(
                  onChanged: (value) => store.name = value,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Pick a username',
                      errorText: store.error.username),
                ),
              ),
              Observer(
                  builder: (_) => AnimatedOpacity(
                      child: const LinearProgressIndicator(),
                      duration: const Duration(milliseconds: 300),
                      opacity: store.isUserCheckPending ? 1 : 0)),
              Observer(
                builder: (_) => TextField(
                  onChanged: (value) => store.email = value,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      errorText: store.error.email),
                ),
              ),
              Observer(
                builder: (_) => TextField(
                  onChanged: (value) => store.password = value,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Set a password',
                      errorText: store.error.password),
                ),
              ),
              RaisedButton(
                child: const Text('Sign up'),
                onPressed: store.validateAll,
              )
            ],
          ),
        ),
      ));
}
