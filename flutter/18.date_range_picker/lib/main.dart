import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: Scaffold(body: _Demo())));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CalendarDatePicker(
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 90)),
          initialDate: DateTime.now(),
          onDateChanged: (DateTime value) {},
        ),
      ),
    );
  }
}
