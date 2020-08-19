import 'package:ad_stream/src/features/request_permission/permission_widget..dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Constructs a [ListView] containing [PermissionWidget] for each available
/// permission.
class PermissionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Permission')),
      body: Center(
        child: ListView(
          children: [
            Permission.location,
            Permission.camera,
            Permission.microphone,
            Permission.storage,
          ].map((permission) => PermissionWidget(permission)).toList(),
        ),
      ),
    );
  }
}
