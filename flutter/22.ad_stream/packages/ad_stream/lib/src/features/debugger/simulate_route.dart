import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:flutter/material.dart';

class SimulateRoute extends StatefulWidget {
  final GpsDebugger gpsDebugger;

  const SimulateRoute({Key key, @required this.gpsDebugger}) : super(key: key);

  @override
  _SimulateRouteState createState() => _SimulateRouteState();
}

class _SimulateRouteState extends State<SimulateRoute> {
  bool isLoading = true;
  List<DebugRoute> routes = [];

  @override
  void initState() {
    widget.gpsDebugger.loadRoutes().then((_) {
      setState(() {
        isLoading = false;
        routes = widget.gpsDebugger.routesToSimulate;
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
              leading: Radio<String>(
                value: r.id,
                groupValue: null,
                onChanged: (_) {},
              ),
              title: Text(r.name),
              onTap: () => Navigator.of(context).pop(r),
            );
          }).toList(),
        ],
      ),
    );
  }
}
