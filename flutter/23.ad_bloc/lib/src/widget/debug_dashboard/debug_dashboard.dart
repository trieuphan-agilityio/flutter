import 'package:ad_bloc/src/service/ad_repository/debug_date_time.dart';
import 'package:ad_bloc/src/service/debugger_factory.dart';
import 'package:ad_bloc/src/service/gps/debug_route.dart';
import 'package:flutter/material.dart';

import 'debug_passenger_photo.dart';

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
  DebuggerFactory get debuggerFactory => widget.debuggerFactory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debugger Dashboard'),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            key: const Key('reload_app'),
            icon: const Icon(Icons.offline_bolt),
            onPressed: _done,
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            key: const Key('debug_dashboard'),
            child: Column(
              children: [
                DebugDriverOnboarded(debuggerFactory: debuggerFactory),
                DebugDriverPickUpPassenger(debuggerFactory: debuggerFactory),
                DebugRoutes(debuggerFactory: debuggerFactory),
                DebugPassengerPhoto(debuggerFactory: debuggerFactory),
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

class DebugDriverOnboarded extends StatefulWidget {
  final DebuggerFactory debuggerFactory;

  const DebugDriverOnboarded({Key key, @required this.debuggerFactory})
      : super(key: key);

  @override
  _DebugDriverOnboardedState createState() => _DebugDriverOnboardedState();
}

class _DebugDriverOnboardedState extends State<DebugDriverOnboarded> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('driver_onboarded'),
      title: const Text('Driver onboarded'),
      trailing: isSelected
          ? Icon(Icons.done, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        setState(() => isSelected = true);
        widget.debuggerFactory.driverOnboarded();
      },
    );
  }
}

class DebugRoutes extends StatefulWidget {
  final DebuggerFactory debuggerFactory;

  const DebugRoutes({Key key, @required this.debuggerFactory})
      : super(key: key);

  @override
  _DebugRoutesState createState() => _DebugRoutesState();
}

class _DebugRoutesState extends State<DebugRoutes> {
  List<DebugRoute> routes = [];
  String selectedId;

  @override
  void initState() {
    // it supposes to renew routes list so that the route stream can be renew
    // after being consumed all events.
    widget.debuggerFactory.loadRoutes().then((newRoutes) {
      setState(() => routes = newRoutes);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (routes.length == 0) return SizedBox.shrink();

    return ExpansionTile(
      key: const Key('load_routes'),
      title: const Text('Driving on route'),
      children: [
        for (final route in routes)
          ListTile(
            key: ValueKey(route.name),
            title: Text(route.name),
            trailing: selectedId == route.id
                ? Icon(Icons.done, color: Theme.of(context).primaryColor)
                : null,
            onTap: () {
              setState(() => selectedId = route.id);
              widget.debuggerFactory.drivingOnRoute(route);
            },
          ),
      ],
    );
  }
}

class DebugDriverPickUpPassenger extends StatefulWidget {
  final DebuggerFactory debuggerFactory;

  const DebugDriverPickUpPassenger({Key key, @required this.debuggerFactory})
      : super(key: key);

  @override
  _DebugDriverPickUpPassengerState createState() =>
      _DebugDriverPickUpPassengerState();
}

class _DebugDriverPickUpPassengerState
    extends State<DebugDriverPickUpPassenger> {
  List<DebugDateTime> debugDateTimes = [];
  String selectedId;

  @override
  void initState() {
    // it supposes to renew DebugDateTimes list so that the route stream can be renew
    // after being consumed all events.
    widget.debuggerFactory.loadDebugDateTimes().then((newValue) {
      setState(() => debugDateTimes = newValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const Key('pick_up_passenger'),
      title: const Text('Driver picked up passenger on'),
      children: [
        for (final debugDateTime in debugDateTimes)
          ListTile(
            key: ValueKey(debugDateTime.name),
            title: Text(debugDateTime.name),
            trailing: selectedId == debugDateTime.id
                ? Icon(Icons.done, color: Theme.of(context).primaryColor)
                : null,
            onTap: () {
              setState(() => selectedId = debugDateTime.id);
              widget.debuggerFactory.driverPickUpPassengerOnDateTime(
                debugDateTime,
              );
            },
          ),
      ],
    );
  }
}
