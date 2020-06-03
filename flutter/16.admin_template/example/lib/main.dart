import 'package:admin_template/admin_template.dart';
import 'package:built_collection/built_collection.dart';
import 'package:example/src/user/user.dart';
import 'package:example/src/web_page/web_page_form.dart';
import 'package:flutter/material.dart';

import 'user.dart';

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
          _WebPageFormDemo(),
        ]),
      ]),
    );
  }
}

/// ===================================================================
/// WebPage form demo
/// ===================================================================

class _WebPageFormDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WebPageForm(),
        ],
      ),
    );
  }
}

/// ===================================================================
/// User form demo
/// ===================================================================

class _UserFormDemo extends StatefulWidget {
  const _UserFormDemo({Key key}) : super(key: key);

  @override
  _UserFormDemoState createState() => _UserFormDemoState();
}

class _UserFormDemoState extends State<_UserFormDemo> {
  User user;

  @override
  void initState() {
    super.initState();
    user = User((b) => b
      ..username = 'johndoe'
      ..email = 'johndoe@example.com'
      ..phone = '561111111'
      ..password = ''
      ..passwordConfirmation = ''
      ..acceptPromotionalEmail = false
      ..groups = ListBuilder());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserForm.edit(user).builder(context, onSaved: (User newValue) {
            setState(() {
              user = newValue;
            });
          }),
          Text(user.toString()),
        ],
      ),
    );
  }
}
