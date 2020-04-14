import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/stream_screen.dart';

import 'counter_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _counter = Counter(0);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Counter>.value(value: _counter),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MaterialApp(routes: {
          '/': (_) => HomeScreen(),
          '/counter': (_) => CounterScreen(),
          '/stream_provider': (_) => BatteryScreen(),
        }),
      ),
    );
  }
}
