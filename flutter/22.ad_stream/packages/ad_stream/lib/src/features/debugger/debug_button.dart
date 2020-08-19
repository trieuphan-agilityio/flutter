import 'package:ad_stream/src/features/debugger/dashboard.dart';
import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Open Debug Dashboard'),
      onPressed: () {
        // open debug dashboard
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return DebugDashboard();
            },
          ),
        );
      },
    );
  }
}
