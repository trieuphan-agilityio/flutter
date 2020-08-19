import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/features/debugger/log_view.dart';
import 'package:ad_stream/src/modules/permission/debugger/permission_debugger.dart';
import 'package:ad_stream/src/modules/power/debugger/power_debugger.dart';
import 'package:ad_stream/src/ui/setting_item.dart';
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

class _DebugDashboard extends StatelessWidget {
  final PermissionDebugger permissionDebugger;
  final PowerDebugger powerDebugger;

  const _DebugDashboard({
    Key key,
    this.permissionDebugger,
    this.powerDebugger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debugger')),
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              _buildHeader('Permission'),
              _buildForPermission(),
              _buildForPower(),
              _buildDivider(),
              _buildHeader('Log'),
              _buildForLog(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(thickness: 1, height: 1);
  }

  Widget _buildHeader(String text) {
    return ListTile(
      dense: true,
      leading: SizedBox.shrink(),
      title: Text(text.toUpperCase()),
    );
  }

  Widget _buildForPermission() {
    return SettingItem(
      title: 'Permission Debugger',
      value: permissionDebugger.isOn,
      onChanged: permissionDebugger.toggle,
    );
  }

  Widget _buildForPower() {
    return SettingItem(
      title: 'Power Debugger',
      value: powerDebugger.isOn,
      onChanged: powerDebugger.toggle,
    );
  }

  Widget _buildForLog(BuildContext context) {
    return ListTile(
      title: Text('Log'),
      leading: SizedBox.shrink(),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => LogView(),
        ));
      },
    );
  }
}
