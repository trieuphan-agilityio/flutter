import 'package:ad_stream/base.dart';
import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/features/request_permission/permission_list.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:flutter/material.dart';

class PermissionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PermissionRequesterUI(
      permissionController: DI.of(context).permissionController,
    );
  }
}

class _PermissionRequesterUI extends StatefulWidget {
  final PermissionController permissionController;

  const _PermissionRequesterUI({
    Key key,
    @required this.permissionController,
  }) : super(key: key);

  @override
  __PermissionRequesterUIState createState() => __PermissionRequesterUIState();
}

class __PermissionRequesterUIState extends State<_PermissionRequesterUI> {
  final Disposer _disposer = Disposer();

  @override
  void initState() {
    // attach start of controller to the view's lifecycle
    widget.permissionController.start();

    final sub = widget.permissionController.state$.listen((permissionState) {
      if (permissionState == PermissionState.denied) {
        showRequestUI();
      }
    });

    _disposer.autoDispose(sub);
    super.initState();
  }

  @override
  void dispose() {
    widget.permissionController.stop();
    _disposer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }

  showRequestUI() {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => PermissionList(
        permissionController: widget.permissionController,
      ),
    ));
  }
}
