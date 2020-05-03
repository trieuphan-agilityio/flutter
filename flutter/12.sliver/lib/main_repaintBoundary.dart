import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  GlobalKey _paintKey = GlobalKey();
  Offset _offset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RepaintBoundary(
            child: CustomPaint(
              painter: ExpensivePainter(),
              isComplex: true,
              willChange: false,
            ),
          ),
          Listener(
            onPointerDown: _updateOffset,
            onPointerMove: _updateOffset,
            child: CustomPaint(
              key: _paintKey,
              painter: MyCustomPainter(_offset),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
              ),
            ),
          )
        ],
      ),
    );
  }

  _updateOffset(PointerEvent event) {
    RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
    Offset offset = referenceBox.globalToLocal(event.position);
    setState(() {
      _offset = offset;
    });
  }
}

class ExpensivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print("Doing expensive paint job");
    Random rand = Random(12345);
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.white,
    ];
    for (int i = 0; i < 5000; i++) {
      canvas.drawCircle(
          Offset(
              rand.nextDouble() * size.width, rand.nextDouble() * size.height),
          10 + rand.nextDouble() * 20,
          Paint()
            ..color = colors[rand.nextInt(colors.length)].withOpacity(0.2));
    }
  }

  @override
  bool shouldRepaint(ExpensivePainter other) => false;
}

class MyCustomPainter extends CustomPainter {
  final Offset _offset;

  MyCustomPainter(this._offset);

  @override
  void paint(Canvas canvas, Size size) {
    if (_offset == null) return;
    canvas.drawCircle(_offset, 10.0, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(MyCustomPainter other) => other._offset != _offset;
}
