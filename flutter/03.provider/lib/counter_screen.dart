import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends ValueNotifier<int> {
  Counter(int value) : super(value);

  void increment() {
    value = value + 1;
  }
}

class CounterScreen extends StatelessWidget {
  final String title;

  CounterScreen({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<Counter>(builder: (context, counter, _) {
              return Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Counter>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
