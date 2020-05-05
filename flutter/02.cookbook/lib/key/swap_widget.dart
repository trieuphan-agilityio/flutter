import 'dart:math';

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: SwapWidgetDemo()));
}

class SwapWidgetDemo extends StatefulWidget {
  @override
  _SwapWidgetDemoState createState() => _SwapWidgetDemoState();
}

class _SwapWidgetDemoState extends State<SwapWidgetDemo> {
  List<Widget> tiles;

  @override
  void initState() {
    super.initState();
    tiles = [
      StatefulColorfulTile(key: UniqueKey()),
      StatefulColorfulTile(key: UniqueKey()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Row(children: tiles)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sentiment_very_satisfied),
        onPressed: swapTiles,
      ),
    );
  }

  void swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }
}

class StatelessColorfulTile extends StatelessWidget {
  final Color color = randomColor();
  @override
  Widget build(BuildContext context) {
    return Container(width: 100, height: 100, color: color);
  }
}

class StatefulColorfulTile extends StatefulWidget {
  StatefulColorfulTile({Key key}) : super(key: key);

  @override
  _StatefulColorfulTileState createState() => _StatefulColorfulTileState();
}

class _StatefulColorfulTileState extends State<StatefulColorfulTile> {
  final Color color = randomColor();
  @override
  Widget build(BuildContext context) {
    return Container(width: 100, height: 100, color: color);
  }
}

Color randomColor() {
  var random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}
