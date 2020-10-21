import 'package:admin_template/admin_template.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.light,
    theme: shrineTheme,
    darkTheme: rallyTheme,
    home: Scaffold(body: _Demo()),
  ));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
