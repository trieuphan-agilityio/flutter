import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(create: (context) => CounterBloc())
      ],
      child: MaterialApp(routes: {
        '/': (_) => HomeScreen(),
        '/counter_stream': (_) => CounterPage(),
        '/counter_bloc': (_) => CounterBlocScreen(),
      }),
    );
  }
}

class CounterBlocScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter BLoC'),
      ),
      body: BlocBuilder<CounterBloc, int>(builder: (context, count) {
        return Center(child: Text('$count', style: TextStyle(fontSize: 24.0)));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(CounterEvent.increment);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield state + 1;
        break;
      case CounterEvent.decrement:
        yield state - 1;
        break;
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC Sample'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/counter_stream');
              },
              child: Text('Counter Stream'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/counter_bloc');
              },
              child: Text('Counter Bloc'),
            )
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
          child: StreamBuilder<int>(
              stream: _streamController.stream,
              initialData: _counter,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text('You hit me: ${snapshot.data} times');
              })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _streamController.sink.add(++_counter);
          },
          child: const Icon(Icons.add)),
    );
  }
}
