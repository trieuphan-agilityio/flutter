import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/features/debugger/log_view.dart';
import 'package:ad_stream/src/features/debugger/simulate_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger_state.dart';
import 'package:ad_stream/src/modules/power/debugger/power_debugger.dart';
import 'package:ad_stream/src/ui/setting_item.dart';
import 'package:flutter/material.dart';

class DebugDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DebugDashboard(
      permissionDebugger: DI.of(context).permissionDebugger,
      powerDebugger: DI.of(context).powerDebugger,
      gpsDebugger: DI.of(context).gpsDebugger,
    );
  }
}

class _DebugDashboard extends StatelessWidget {
  final PermissionDebugger permissionDebugger;
  final PowerDebugger powerDebugger;
  final GpsDebugger gpsDebugger;

  const _DebugDashboard({
    Key key,
    @required this.permissionDebugger,
    @required this.powerDebugger,
    @required this.gpsDebugger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debugger')),
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              _buildHeader('Service Manager'),
              _buildForPermission(context),
              _buildForPower(),
              _buildDivider(),
              _buildHeader('Gps'),
              _buildForGps(context),
              _buildForSimulateRoute(context),
              _buildDivider(),
              _buildHeader('Others'),
              _buildForLog(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      child: Divider(thickness: 1, height: 1),
      padding: EdgeInsets.symmetric(vertical: 3),
    );
  }

  Widget _buildHeader(String text) {
    return ListTile(
      dense: true,
      title: Text(text.toUpperCase()),
    );
  }

  Widget _buildForPermission(BuildContext context) {
    return ValueListenableBuilder<PermissionDebuggerState>(
      valueListenable: permissionDebugger.debugState,
      builder: (context, currentDebugState, _) => ListTile(
        title: Text('Permission Debugger'),
        subtitle: Text(currentDebugState.name),
        onTap: () async {
          final chose = await showModalBottomSheet<PermissionDebuggerState>(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...PermissionDebuggerState.values.map((state) {
                      return ListTile(
                        leading: Radio<int>(
                          value: state.value,
                          groupValue:
                              currentDebugState == state ? state.value : null,
                          onChanged: (_) {},
                        ),
                        title: Text(state.name),
                        onTap: () => Navigator.of(context).pop(state),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: FlatButton(
                          textColor: Theme.of(context).colorScheme.primary,
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop()),
                    ),
                  ],
                ),
              );
            },
          );

          if (chose == null) return;

          permissionDebugger.setDebugState(chose);
        },
      ),
    );
  }

  Widget _buildForPower() {
    return SettingItem(
        title: 'Power Debugger',
        value: powerDebugger.isOn,
        onTap: powerDebugger.toggle);
  }

  Widget _buildForGps(BuildContext context) {
    return SettingItem(
        title: 'Gps Debugger',
        value: gpsDebugger.isOn,
        onTap: gpsDebugger.toggle);
  }

  Widget _buildForSimulateRoute(BuildContext context) {
    return ListTile(
      title: Text('Simulate Route'),
      onTap: () async {
        final DebugRoute chose = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SimulateRoute(gpsDebugger: gpsDebugger)),
        );

        if (chose != null) gpsDebugger.simulateRoute(chose);
      },
    );
  }

  Widget _buildForLog(BuildContext context) {
    return ListTile(
      title: Text('Log'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => LogView(),
        ));
      },
    );
  }
}
