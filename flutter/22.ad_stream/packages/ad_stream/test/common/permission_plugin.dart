import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

const kPermissionChannel = 'flutter.baseflow.com/permissions/methods';

// Code of granted state of the permission.
// not sure why PermissionStatus.granted.value doesn't work.
final kPermissionGranted = 1;

// Code of denied state of the permission.
final kPermissionDenied = 0;

final List<Permission> _kAllPermissions = [
  Permission.location,
  Permission.camera,
  Permission.microphone,
  Permission.storage,
];

permissionPluginCleanUp() {
  MethodChannel(kPermissionChannel).setMockMethodCallHandler(null);
}

permissionPluginAllAllowed() {
  permissionPluginWithContext(Map.fromIterable(
    _kAllPermissions,
    key: (p) => p,
    value: (_) => kPermissionGranted,
  ));
}

permissionPluginAllDenied() {
  permissionPluginWithContext(Map.fromIterable(
    _kAllPermissions,
    key: (e) => e,
    value: (_) => kPermissionDenied,
  ));
}

permissionPluginWithContext(Map<Permission, int> context) {
  MethodChannel(kPermissionChannel).setMockMethodCallHandler(
    (MethodCall methodCall) async {
      _verifyMethodArguments(context, methodCall.arguments);
      switch (methodCall.method) {
        case 'checkPermissionStatus':
          return context[Permission.byValue(methodCall.arguments)];
        default:
          throw 'Method is not supported';
      }
    },
  );
}

_verifyMethodArguments(
  Map<Permission, int> context,
  dynamic arguments,
) {
  if (!context.keys.contains(Permission.byValue(arguments))) {
    throw 'Permission is not supported';
  }
}
