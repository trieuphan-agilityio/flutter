import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mobx_practices/demo/drawer.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget();

  @override
  State<StatefulWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  final Clock clock = Clock();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
      ),
      drawer: DemoDrawer(),
      body: Center(
        child: Observer(builder: (_) {
          // The simple de-referencing of clock.now is enough to keep triggering it every second
          final time = clock.now;
          final formattedTime = [time.hour, time.minute, time.second].join(':');

          return Text(formattedTime,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ));
        }),
      ));
}

class Clock {
  Clock() {
    _atom = Atom(
        name: 'Clock Atom', onObserved: _startTimer, onUnobserved: _stopTimer);
  }

  DateTime get now {
    _atom.reportObserved();
    return DateTime.now();
  }

  Atom _atom;
  Timer _timer;

  void _startTimer() {
    print('Clock started ticking');

    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }

    print('Clock stopped ticking');
  }

  void _onTick(_) {
    _atom.reportChanged();
  }
}
