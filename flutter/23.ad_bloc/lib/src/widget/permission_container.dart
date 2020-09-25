import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/src/service/permission_controller.dart';

import 'permission_list.dart';

class PermissionContainer extends StatelessWidget {
  final Widget child;

  const PermissionContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PermissionRequesterUI(
      permissionController: Provider.of<PermissionController>(context),
      child: child,
    );
  }
}

class _PermissionRequesterUI extends StatefulWidget {
  final PermissionController permissionController;
  final Widget child;

  const _PermissionRequesterUI({
    Key key,
    @required this.permissionController,
    @required this.child,
  }) : super(key: key);

  @override
  __PermissionRequesterUIState createState() => __PermissionRequesterUIState();
}

class __PermissionRequesterUIState extends State<_PermissionRequesterUI>
    with AutoDisposeMixin {
  Route<void> requestUIRoute;

  @override
  void initState() {
    final sub = widget.permissionController.isAllowed$.listen((isAllowed) {
      if (isAllowed)
        _dismissRequestUI();
      else
        _showRequestUI();
    });

    autoDispose(sub);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _showRequestUI() {
    // to be safe, clean the exist UI if any before showing new one.
    _dismissRequestUI();

    requestUIRoute = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => PermissionList(
        permissions: widget.permissionController.permissions,
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(requestUIRoute);
  }

  _dismissRequestUI() {
    if (requestUIRoute != null) {
      Navigator.of(context).removeRoute(requestUIRoute);
      requestUIRoute = null;
    }
  }
}
