import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Hello world"),
          ),
          body: Main()),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    Key key,
  }) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var hitCount = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          hitCount = hitCount + 2;
        });
      },
      child: Container(
          decoration: BoxDecoration(color: Colors.blueGrey),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Hello, world! $hitCount'),
                IconButton(
                    icon: Icon(Icons.lightbulb_outline),
                    tooltip: 'Hit harder !!!',
                    onPressed: () {
                      setState(() {
                        hitCount += 1;
                      });
                    }),
              ],
            ),
          )),
    );
  }
}
