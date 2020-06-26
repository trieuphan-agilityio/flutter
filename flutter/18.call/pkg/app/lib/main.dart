import 'package:app/src/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget child) {
        return child;
      },
      routes: {
        '/': (_) => HomeWidget(),
      },
    );
  }
}
