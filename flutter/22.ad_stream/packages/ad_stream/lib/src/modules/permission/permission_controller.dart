import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:rxdart/rxdart.dart';

abstract class PermissionController {
  Stream<PermissionState> get state$;
}

class PermissionControllerImpl implements PermissionController {
  final StreamController<PermissionState> _status$Controller;

  PermissionControllerImpl()
      : _status$Controller = BehaviorSubject.seeded(PermissionState.DENIED);

  Stream<PermissionState> get state$ => _status$Controller.stream;
}
