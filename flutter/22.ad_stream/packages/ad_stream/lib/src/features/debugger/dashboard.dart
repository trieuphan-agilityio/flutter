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
              _buildForPermission(context),
              _buildForPower(),
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
    return Divider(thickness: 1, height: 1);
  }

  Widget _buildHeader(String text) {
    return ListTile(
      dense: true,
      leading: SizedBox.shrink(),
      title: Text(text.toUpperCase()),
    );
  }

  Widget _buildForPermission(BuildContext context) {
    return ValueListenableBuilder<PermissionDebuggerState>(
      valueListenable: permissionDebugger.debugState,
      builder: (context, currentDebugState, _) => ListTile(
        title: Text('Permission Debugger'),
        subtitle: Text(currentDebugState.name),
        leading: SizedBox.shrink(),
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
      onTap: powerDebugger.toggle,
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
