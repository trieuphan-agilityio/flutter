import 'package:ad_bloc/src/service/debugger_factory.dart';
import 'package:flutter/material.dart';

class DebugDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Debug(debuggerFactory: DebuggerFactory.of(context));
  }
}

class _Debug extends StatefulWidget {
  final DebuggerFactory debuggerFactory;

  const _Debug({Key key, @required this.debuggerFactory}) : super(key: key);

  @override
  __DebugState createState() => __DebugState();
}

class __DebugState extends State<_Debug> {
  DebuggerFactory get debug => widget.debuggerFactory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debugger Dashboard'),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            key: const Key('debug_dashboard'),
            child: Column(
              children: [
                ListTile(
                  key: const Key('driver_onboarded'),
                  title: const Text('Driver onboarded'),
                  onTap: () {
                    debug.driverOnboarded();
                    _done();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _done() {
    Navigator.pushNamed(context, '/');
  }
}
