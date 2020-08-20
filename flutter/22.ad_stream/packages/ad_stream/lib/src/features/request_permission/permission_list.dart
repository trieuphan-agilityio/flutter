import 'package:ad_stream/src/features/request_permission/permission_widget..dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Constructs a [ListView] containing [PermissionWidget] for each available
/// permission.
class PermissionList extends StatelessWidget {
  final List<Permission> permissions;

  const PermissionList({Key key, @required this.permissions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Permission')),
      body: Center(
        child: ListView(
          children: permissions
              .map((permission) => PermissionWidget(permission))
              .toList(),
        ),
      ),
    );
  }
}
