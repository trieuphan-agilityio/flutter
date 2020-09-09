import 'package:ad_stream/base.dart';
import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:flutter/material.dart';

class SimulateRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SimulateRoute(
      gpsDebugger: DI.of(context).gpsDebugger,
    );
  }
}

class _SimulateRoute extends StatefulWidget {
  final GpsDebugger gpsDebugger;

  const _SimulateRoute({Key key, @required this.gpsDebugger}) : super(key: key);

  @override
  __SimulateRouteState createState() => __SimulateRouteState();
}

class __SimulateRouteState extends State<_SimulateRoute> {
  bool isLoading = true;
  List<DebugRoute> routes = [];

  @override
  void initState() {
    // it supposes to renew routes list so that the route stream can be renew
    // after being consumer all events.
    widget.gpsDebugger.loadRoutes().then((newRoutes) {
      setState(() {
        isLoading = false;
        routes = newRoutes;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulate Route')),
      body: isLoading ? _buildIndicator() : _buildRoutes(),
    );
  }

  Widget _buildIndicator() {
    return CircularProgressIndicator();
  }

  Widget _buildRoutes() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...routes.map((r) {
            return ListTile(
              key: ValueKey(r.name),
              leading: Radio<String>(
                value: r.id,
                groupValue: null,
                onChanged: (_) {},
              ),
              title: Text(r.name),
              onTap: () {
                widget.gpsDebugger.simulateRoute(r);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
