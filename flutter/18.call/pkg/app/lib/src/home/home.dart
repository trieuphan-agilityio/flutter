import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      persistentFooterButtons: [
        FlatButton.icon(
          onPressed: () {},
          icon: Icon(Icons.history),
          label: Text('Recent'),
        ),
        FlatButton.icon(
          onPressed: () {},
          icon: Icon(Icons.group),
          label: Text('People'),
        ),
      ],
    );
  }
}
