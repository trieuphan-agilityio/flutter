import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_status.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@visibleForTesting
class AlwaysAllowPermissionController implements PermissionController {
  final StreamController<PermissionStatus> status$Controller;

  AlwaysAllowPermissionController()
      : status$Controller = BehaviorSubject.seeded(PermissionStatus.ALLOWED);

  Stream<PermissionStatus> get status$ => status$Controller.stream;
}
