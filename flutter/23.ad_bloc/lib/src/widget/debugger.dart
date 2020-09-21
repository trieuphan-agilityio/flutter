import 'package:ad_bloc/src/service/debugger.dart';
import 'package:flutter/material.dart';

class Debugger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Debugger(debuggerFactory: DebuggerFactory.of(context));
  }
}

class _Debugger extends StatefulWidget {
  final DebuggerFactory debuggerFactory;

  const _Debugger({Key key, @required this.debuggerFactory}) : super(key: key);

  @override
  __DebuggerState createState() => __DebuggerState();
}

class __DebuggerState extends State<_Debugger> {
  DebuggerFactory get debuggerFactory => widget.debuggerFactory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Container()));
  }
}
