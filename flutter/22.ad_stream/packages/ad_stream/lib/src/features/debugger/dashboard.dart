import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/features/debugger/log_view.dart';
import 'package:ad_stream/src/features/debugger/simulate_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/debug_route.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:ad_stream/src/modules/on_trip/face.dart';
import 'package:ad_stream/src/modules/on_trip/photo.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger_state.dart';
import 'package:ad_stream/src/modules/power/debugger/power_debugger.dart';
import 'package:ad_stream/src/ui/setting_item.dart';
import 'package:flutter/material.dart';

import 'choose_config.dart';

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
          child: SingleChildScrollView(
            key: const Key('debug_dashboard'),
            child: Column(
              children: [
                _buildHeader('Stories'),
                ..._buildStories(context),
                _buildDivider(),
                _buildHeader('Service Manager'),
                _buildForPermission(context),
                _buildForPower(),
                _buildDivider(),
                _buildHeader('Gps'),
                _buildForGps(context),
                _buildForSimulateRoute(context),
                _buildDivider(),
                _buildHeader('On Trip'),
                _buildForFace(context),
                _buildDivider(),
                _buildHeader('Others'),
                _buildForConfig(context),
                _buildForLog(context),
              ],
            ),
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

  Iterable<Widget> _buildStories(BuildContext context) {
    return [
      ListTile(
        key: const Key('story_visitor'),
        title: Text('I am a visitor'),
        onTap: () {
          permissionDebugger.setDebugState(PermissionDebuggerState.allow);
          powerDebugger.toggle(true);
          powerDebugger.strong();
          gpsDebugger.toggle(true);
        },
      ),
      ListTile(
        key: const Key('story_video_ad'),
        title: Text('I am seeing an video ad is playing'),
        onTap: () {
          permissionDebugger.setDebugState(PermissionDebuggerState.allow);
          powerDebugger.toggle(true);
          powerDebugger.strong();
          gpsDebugger.toggle(true);
        },
      ),
      ListTile(
        key: const Key('story_pick_up_passenger'),
        title: Text('Driver pick up a passenger'),
        onTap: () async {
          permissionDebugger.setDebugState(PermissionDebuggerState.allow);
          powerDebugger.toggle(true);
          powerDebugger.strong();

          // simulate route 496NgoQuyen_604NuiThanh in sample_data.dart
          final routes = await gpsDebugger.loadRoutes();
          final testRoute = routes[0];
          gpsDebugger.simulateRoute(testRoute);
        },
      ),
      ListTile(
        key: const Key('story_about_finish_trip'),
        title: Text('Passenger is about to finish a trip'),
        onTap: () {},
      ),
    ];
  }

  Widget _buildForPermission(BuildContext context) {
    return ValueListenableBuilder<PermissionDebuggerState>(
      valueListenable: permissionDebugger.debugState,
      builder: (context, currentDebugState, _) => ListTile(
        key: const Key('permission_debugger'),
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
                        key: Key('permission_debugger_state_${state.value}'),
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
        key: const Key('power_debugger'),
        title: 'Power Debugger',
        value: powerDebugger.isOn,
        onTap: powerDebugger.toggle);
  }

  Widget _buildForGps(BuildContext context) {
    return SettingItem(
        key: const Key('gps_debugger'),
        title: 'Gps Debugger',
        value: gpsDebugger.isOn,
        onTap: gpsDebugger.toggle);
  }

  Widget _buildForSimulateRoute(BuildContext context) {
    return ListTile(
      key: const Key('simulate_route'),
      title: Text('Simulate Route'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SimulateRoute(),
        ));
      },
    );
  }

  Widget _buildForFace(BuildContext context) {
    final faceDebugger = DI.of(context).faceDebugger;
    return ListTile(
      key: const Key('face_debugger'),
      title: Text('Face Debugger'),
      subtitle: ValueListenableBuilder(
        valueListenable: faceDebugger.isOn,
        builder: (_, value, __) =>
            Text('${faceDebugger.isOn.value ? "On" : "Off"}'),
      ),
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    key: const Key('face_debugger_off'),
                    leading: Radio<int>(
                        value: 1, groupValue: null, onChanged: (_) {}),
                    title: Text('Off'),
                    onTap: () {
                      faceDebugger.toggle(false);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    key: const Key('face_debugger_no_face'),
                    leading: Radio<int>(
                        value: 2, groupValue: null, onChanged: (_) {}),
                    title: Text('No face'),
                    onTap: () {
                      faceDebugger.noFace();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    key: const Key('face_debugger_use_faces'),
                    leading: Radio<int>(
                        value: 2, groupValue: null, onChanged: (_) {}),
                    title: Text('Use faces'),
                    onTap: () {
                      faceDebugger.useFaces([
                        Face('face-id', Photo('path/to/photo1.jpg')),
                      ]);
                      Navigator.of(context).pop();
                    },
                  ),
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
      },
    );
  }

  Widget _buildForLog(BuildContext context) {
    return ListTile(
      key: const Key('log'),
      title: Text('Log'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LogView(),
        ));
      },
    );
  }

  Widget _buildForConfig(BuildContext context) {
    return ListTile(
      key: const Key('config'),
      title: Text('Config'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChooseConfig(),
        ));
      },
    );
  }
}
