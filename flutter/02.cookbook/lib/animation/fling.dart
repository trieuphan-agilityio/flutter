import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: _Demo()));
}

class _Demo extends StatefulWidget {
  @override
  __DemoState createState() => __DemoState();
}

class __DemoState extends State<_Demo> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<int> alpha;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    alpha = IntTween(begin: 0, end: 255).animate(controller)
      ..addListener(() {
        print(alpha.value);
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
