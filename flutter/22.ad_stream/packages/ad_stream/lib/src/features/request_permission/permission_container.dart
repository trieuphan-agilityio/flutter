import 'package:ad_stream/base.dart';
import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/features/request_permission/permission_list.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:flutter/material.dart';

class PermissionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PermissionRequesterUI(
      permissionController: DI.of(context).permissionController,
    );
  }
}

class PermissionRequesterUI extends StatefulWidget {
  final PermissionController permissionController;

  const PermissionRequesterUI({
    Key key,
    @required this.permissionController,
  }) : super(key: key);

  @override
  _PermissionRequesterUIState createState() => _PermissionRequesterUIState();
}

class _PermissionRequesterUIState extends State<PermissionRequesterUI> {
  final Disposer _disposer = Disposer();
  bool showGrantPermissionButton = true;

  @override
  void initState() {
    final sub = widget.permissionController.state$.listen((permissionState) {
      if (permissionState == PermissionState.denied) {
        showRequestUI();
        setState(() => showGrantPermissionButton = false);
      } else {
        setState(() => showGrantPermissionButton = true);
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
    return showGrantPermissionButton
        ? SizedBox.shrink()
        : RaisedButton(
            child: Text('Grant permission'),
            onPressed: () => showRequestUI(),
          );
  }

  showRequestUI() {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => PermissionList(),
    ));
  }
}
