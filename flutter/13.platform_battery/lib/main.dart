import 'package:battery/battery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final battery = Battery();

class _MyHomePageState extends State<MyHomePage> {
  int batteryLevel;

  void retrieveBatteryLevel() async {
    print('does this run?');
    try {
      final _batteryLevel = await battery.batteryLevel;
      print(_batteryLevel);
      setState(() {
        batteryLevel = _batteryLevel;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            batteryLevel == null
                ? Text('Tap on the Magic button to see Battery level.')
                : Text('Battery level is'),
            if (batteryLevel != null)
              Text(
                '$batteryLevel%',
                style: Theme.of(context).textTheme.headline1,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: retrieveBatteryLevel,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
