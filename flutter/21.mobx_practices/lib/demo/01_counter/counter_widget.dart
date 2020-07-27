import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_practices/demo/drawer.dart';

import 'counter.dart'; // Import the Counter

final counter = Counter(); // Instantiate the store

class CounterWidget extends StatelessWidget {
  const CounterWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DemoDrawer(),
      appBar: AppBar(
        title: Text('MobX Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Wrapping in the Observer will automatically re-render on changes to counter.value
            Observer(
              builder: (_) => Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
