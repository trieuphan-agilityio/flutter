import 'dart:async';

import 'package:ad_stream/src/modules/permission/permission_status.dart';

abstract class PermissionController {
  Stream<PermissionStatus> get status$;
}

class PermissionControllerImpl implements PermissionController {
  Stream<PermissionStatus> get status$ => Stream.empty();
}
