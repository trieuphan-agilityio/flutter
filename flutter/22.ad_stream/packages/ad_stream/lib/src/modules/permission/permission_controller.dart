import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_status.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionController {
  Stream<PermissionStatus> get status$;
}

class PermissionControllerImpl implements PermissionController {
  final StreamController<PermissionStatus> _status$Controller;

  PermissionControllerImpl()
      : _status$Controller = BehaviorSubject.seeded(PermissionStatus.DENIED);

  Stream<PermissionStatus> get status$ => _status$Controller.stream;
}
