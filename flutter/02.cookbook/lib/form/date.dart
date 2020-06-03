import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: _Demo(),
  ));
}

class _Demo extends StatefulWidget {
  @override
  __DemoState createState() => __DemoState();
}

class __DemoState extends State<_Demo> {
  String log = '';

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DateTime Input Demo')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 6)),
                  initialEntryMode: DatePickerEntryMode.calendar,
                );

                if (selectedDate == null) return;

                setState(() {
                  log = 'picked ${selectedDate.toIso8601String()}';
                });
              },
              child: Text('Pick Start Date'),
            ),
            InputDatePickerFormField(
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 6)),
              errorFormatText: 'Error! format text',
              errorInvalidText: 'Error! invalid text',
              onDateSubmitted: (newValue) {
                setState(() {
                  log = 'onDateSubmitted: ${newValue.toIso8601String()}';
                });
              },
              onDateSaved: (newValue) {
                setState(() {
                  log = 'onDateSaved: ${newValue.toIso8601String()}';
                });
              },
            ),
            Text(log),
            RaisedButton(
              onPressed: () {
                _formKey.currentState.save();
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
