import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:flutter/material.dart';

class Debugger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Debugger(
      permissionDebugger: DI.of(context).permissionDebugger,
    );
  }
}

class _Debugger extends StatefulWidget {
  final PermissionDebugger permissionDebugger;

  const _Debugger({Key key, this.permissionDebugger}) : super(key: key);

  @override
  __DebuggerState createState() => __DebuggerState();
}

class __DebuggerState extends State<_Debugger> {
  bool isPermissionDebuggerEnabled;

  @override
  void initState() {
    isPermissionDebuggerEnabled = widget.permissionDebugger.isEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          child: Column(
            children: [
              Switch.adaptive(
                  value: isPermissionDebuggerEnabled,
                  onChanged: (newValue) {
                    setState(() {
                      isPermissionDebuggerEnabled = newValue;
                    });
                  }),
              FlatButton(
                onPressed: () {
                  widget.permissionDebugger.isEnabled =
                      isPermissionDebuggerEnabled;
                  Navigator.of(context).pop();
                },
                child: Text('Done'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
