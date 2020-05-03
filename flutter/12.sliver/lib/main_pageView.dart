import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: _Demo()));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(color: Colors.green),
        Container(color: Colors.blue),
        ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              color: index % 2 == 0 ? Colors.amber : Colors.blueAccent,
            );
          },
        ),
      ],
    );
  }
}
