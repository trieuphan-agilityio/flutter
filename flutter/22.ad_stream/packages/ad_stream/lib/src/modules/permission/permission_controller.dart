import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionController {
  Stream<PermissionState> get state$;
}

class PermissionControllerImpl
    with ServiceMixin
    implements PermissionController, Service {
  final StreamController<PermissionState> _status$Controller;

  PermissionControllerImpl()
      : _status$Controller = BehaviorSubject<PermissionState>();

  Stream<PermissionState> get state$ => _status$Controller.stream;

  @override
  Future<void> start() {
    super.start();
    return null;
  }

  @override
  Future<void> stop() {
    super.stop();

    return null;
  }
}
