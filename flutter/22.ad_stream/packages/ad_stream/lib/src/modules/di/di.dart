import 'package:ad_stream/src/modules/ad/ad_module.dart';
import 'package:ad_stream/src/modules/gps/gps_module.dart';
import 'package:ad_stream/src/modules/permission/permission_module.dart';
import 'package:ad_stream/src/modules/power/power_module.dart';
import 'package:ad_stream/src/modules/supervisor/supervisor_module.dart';
import 'package:flutter/widgets.dart';
import 'package:inject/inject.dart';
import 'package:provider/provider.dart';

import 'di.inject.dart' as g;

/// Used as a blueprint to generate an injector
@Injector(const [
  AdModule,
  PowerModule,
  PermissionModule,
  SupervisorModule,
  GpsModule,
])
abstract class DI
    implements
        AdModuleLocator,
        PowerModuleLocator,
        PermissionModuleLocator,
        SupervisorModuleLocator,
        GpsModuleLocator {
  static DI of(BuildContext context) {
    return Provider.of<DI>(context);
  }

  /// Boilerplate code to wire Inject's things together.
  static Future<DI> create(
    AdModule adModule,
    PowerModule powerModule,
    PermissionModule permissionModule,
    SupervisorModule supervisorModule,
    GpsModule gpsModule,
  ) async {
    return await g.DI$Injector.create(
      adModule,
      powerModule,
      permissionModule,
      supervisorModule,
      gpsModule,
    );
  }
}

/// Expose global level method to initialise Dependency Injection.
///
/// In testing you may need to create some other fake modules instead.
///
/// For example:
///
/// Future<DI> createDI() {
///   return DI.create(
///     AdFakeServices(),
///     PowerMockServices(),
///     PermissionAlwaysAllowedServices(),
///   );
/// }
Future<DI> createDI() {
  return DI.create(
    AdModule(),
    PowerModule(),
    PermissionModule(),
    SupervisorModule(),
    GpsModule(),
  );
}
