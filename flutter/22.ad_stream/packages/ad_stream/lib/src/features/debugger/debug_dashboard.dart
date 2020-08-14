import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/power/debugger/power_debugger.dart';
import 'package:flutter/material.dart';

class DebugDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DebugDashboard(
      permissionDebugger: DI.of(context).permissionDebugger,
      powerDebugger: DI.of(context).powerDebugger,
    );
  }
}

class _DebugDashboard extends StatefulWidget {
  final PermissionDebugger permissionDebugger;
  final PowerDebugger powerDebugger;

  const _DebugDashboard({Key key, this.permissionDebugger, this.powerDebugger})
      : super(key: key);

  @override
  _DebugDashboardState createState() => _DebugDashboardState();
}

class _DebugDashboardState extends State<_DebugDashboard> {
  bool isPermissionDebuggerEnabled;
  bool isPowerDebuggerEnabled;

  @override
  void initState() {
    isPermissionDebuggerEnabled = widget.permissionDebugger.isEnabled;
    isPowerDebuggerEnabled = widget.powerDebugger.isEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debugger'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              widget.permissionDebugger.isEnabled = isPermissionDebuggerEnabled;
              widget.powerDebugger.isEnabled = isPowerDebuggerEnabled;
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              ...ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  title: Text('Debugger for Permission Controller'),
                  trailing: Switch.adaptive(
                    value: isPermissionDebuggerEnabled,
                    onChanged: (newValue) {
                      setState(() {
                        isPermissionDebuggerEnabled = newValue;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Debugger for Power Provider'),
                  trailing: Switch.adaptive(
                    value: isPowerDebuggerEnabled,
                    onChanged: (newValue) {
                      setState(() {
                        isPowerDebuggerEnabled = newValue;
                      });
                    },
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
