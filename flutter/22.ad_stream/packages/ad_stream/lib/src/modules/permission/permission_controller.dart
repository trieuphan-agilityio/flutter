enum PermissionStatus {
  // all permissions were granted
  ALLOWED,

  // one or more permissions were denied
  DENIED
}

abstract class PermissionController {
  Stream<PermissionStatus> get status;
}
