import 'package:ad_stream/di.dart';
import 'package:flutter/widgets.dart';
import 'package:inject/inject.dart';
import 'package:provider/provider.dart';

import 'di.inject.dart' as g;

/// Used as a blueprint to generate an injector
@Injector(const [
  AdModule,
  ConfigModule,
  CommonModule,
  StorageModule,
  PowerModule,
  PermissionModule,
  ServiceManagerModule,
  GpsModule,
  OnTripModule,
])
abstract class DI
    implements
        AdModuleLocator,
        ConfigModuleLocator,
        CommonModuleLocator,
        StorageModuleLocator,
        PowerModuleLocator,
        PermissionModuleLocator,
        ServiceManagerModuleLocator,
        GpsModuleLocator,
        OnTripModuleLocator {
  static DI of(BuildContext context) {
    return Provider.of<DI>(context);
  }

  /// Boilerplate code to wire Inject's things together.
  static Future<DI> create(
    AdModule adModule,
    ConfigModule configModule,
    CommonModule commonModule,
    StorageModule storageModule,
    PowerModule powerModule,
    PermissionModule permissionModule,
    ServiceManagerModule serviceManagerModule,
    GpsModule gpsModule,
    OnTripModule onTripModule,
  ) async {
    return await g.DI$Injector.create(
      adModule,
      configModule,
      commonModule,
      storageModule,
      powerModule,
      permissionModule,
      serviceManagerModule,
      gpsModule,
      onTripModule,
    );
  }
}

/// Expose global level method to initialise Dependency Injection.
///
/// In testing you may need to create some other fake modules instead.
///
/// For example:
///
/// Future<DI> _createDI() {
///   return DI.create(
///     AdFakeServices(),
///     PowerMockServices(),
///     PermissionAlwaysAllowedServices(),
///   );
/// }
Future<DI> createDI() {
  /// Asynchronously create Dependency Injection tree.
  return Future(() {
    return DI.create(
      AdModule(),
      ConfigModule(),
      CommonModule(),
      StorageModule(),
      PowerModule(),
      PermissionModule(),
      ServiceManagerModule(),
      GpsModule(),
      OnTripModule(),
    );
  });
}
