import 'dart:async';

import 'package:rxdart/rxdart.dart';

enum PermissionStatus {
  // all permissions were granted
  ALLOWED,

  // one or more permissions were denied
  DENIED
}

abstract class PermissionController {
  Stream<PermissionStatus> get status$;
}

class PermissionControllerImpl implements PermissionController {
  @override
  // TODO: implement status
  Stream<PermissionStatus> get status$ => throw UnimplementedError();
}

class AlwaysAllowPermissionController implements PermissionController {
  final StreamController<PermissionStatus> status$Controller;

  AlwaysAllowPermissionController()
      : status$Controller = BehaviorSubject.seeded(PermissionStatus.ALLOWED);

  Stream<PermissionStatus> get status$ => status$Controller.stream;
}
