import 'package:flutter/material.dart';

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

final ButtonStyle textButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

class DemoButtonStyle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Button Style')),
      body: Container(
        width: 400,
        height: 250,
        child: Column(
          children: [
            TextButton(
              style: textButtonStyle,
              onPressed: () {},
              child: Text('Looks like a FlatButton'),
            ),
          ],
        ),
      ),
    );
  }
}
