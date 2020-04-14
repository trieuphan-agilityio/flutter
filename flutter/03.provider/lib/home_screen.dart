import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My Demo')),
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Counter'),
              onTap: () {
                Navigator.of(context).pushNamed('/counter');
              },
            ),
            ListTile(
              leading: Icon(Icons.blur_linear),
              title: Text('StreamProvider'),
              onTap: () {
                Navigator.of(context).pushNamed('/stream_provider');
              }
            )
          ],
        )),
        body: Center(child: Text('Select demo from the Drawer')),
      ),
    );
  }
}
