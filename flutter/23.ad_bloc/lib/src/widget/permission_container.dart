import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:ad_bloc/src/service/permission_controller.dart';
import 'package:flutter/material.dart';

class PermissionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Permission(
      appEventSink: AppBloc.of(context),
      permissionController: Provider.of<PermissionController>(context),
    );
  }
}

class _Permission extends StatefulWidget {
  final EventSink<AppEvent> appEventSink;
  final PermissionController permissionController;

  const _Permission(
      {Key key,
      @required this.appEventSink,
      @required this.permissionController})
      : super(key: key);

  @override
  __PermissionState createState() => __PermissionState();
}

class __PermissionState extends State<_Permission> with AutoDisposeMixin {
  @override
  void initState() {
    final sub = widget.permissionController.isAllowed$.listen((isAllowed) {
      widget.appEventSink.add(Permitted(isAllowed));
    });
    autoDispose(sub);

    widget.permissionController.start();

    super.initState();
  }

  @override
  void dispose() {
    widget.permissionController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
