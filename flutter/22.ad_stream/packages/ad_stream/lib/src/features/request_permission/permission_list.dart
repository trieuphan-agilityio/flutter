import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/features/request_permission/permission_widget..dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:flutter/material.dart';

/// Constructs a [ListView] containing [PermissionWidget] for each available
/// permission.
class PermissionList extends StatefulWidget {
  final PermissionController permissionController;

  const PermissionList({Key key, @required this.permissionController})
      : super(key: key);

  @override
  _PermissionListState createState() => _PermissionListState();
}

class _PermissionListState extends State<PermissionList> {
  final Disposer _disposer = Disposer();

  @override
  void initState() {
    final sub = widget.permissionController.state$.listen((permissionState) {
      if (permissionState == PermissionState.allowed) {
        Navigator.of(context).pop();
      }
    });
    _disposer.autoDispose(sub);
    super.initState();
  }

  @override
  void dispose() {
    _disposer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use WillPopScope to prevent the page from being popped by the system.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Permission'),
          leading: null,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: ListView(
            children: widget.permissionController.permissions
                .map((permission) => PermissionWidget(permission))
                .toList(),
          ),
        ),
      ),
    );
  }
}
