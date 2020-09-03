import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/debugger/drawer.dart';
import 'package:ad_stream/src/features/request_permission/permission_widget..dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:flutter/material.dart';

/// Constructs a [ListView] containing [PermissionWidget] for each available
/// permission.
class PermissionList extends StatelessWidget {
  final PermissionController permissionController;

  const PermissionList({Key key, @required this.permissionController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use WillPopScope to prevent the page from being popped by the system.
    return WillPopScope(
      key: const Key('permission_list'),
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: Text('Permission')),
        drawer: DebugDrawer(),
        body: Center(
          child: ListView(
            children: permissionController.permissions
                .map((permission) => PermissionWidget(permission))
                .toList(),
          ),
        ),
      ),
    );
  }
}
