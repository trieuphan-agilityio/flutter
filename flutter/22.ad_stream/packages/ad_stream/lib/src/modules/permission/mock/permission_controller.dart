import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

@visibleForTesting
class AlwaysAllowPermissionController
    with ServiceMixin
    implements PermissionController {
  final StreamController<PermissionState> state$Controller;

  AlwaysAllowPermissionController()
      : state$Controller = BehaviorSubject.seeded(PermissionState.allowed);

  Stream<PermissionState> get state$ => state$Controller.stream;

  List<Permission> get permissions => [];
}
