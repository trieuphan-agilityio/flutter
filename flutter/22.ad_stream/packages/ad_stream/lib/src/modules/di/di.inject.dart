import 'di.dart' as _i1;
import '../ad/ad_module.dart' as _i2;
import '../service_manager/service_manager_module.dart' as _i3;
import '../power/power_module.dart' as _i4;
import '../power/power_provider.dart' as _i5;
import '../permission/permission_module.dart' as _i6;
import '../permission/debugger/permission_debugger.dart' as _i7;
import '../permission/permission_controller.dart' as _i8;
import '../service_manager/service_manager.dart' as _i9;
import '../gps/gps_module.dart' as _i10;
import '../gps/gps_controller.dart' as _i11;
import '../../base/config.dart' as _i12;
import '../ad/ad_repository.dart' as _i13;
import '../ad/ad_scheduler.dart' as _i14;
import '../../features/ad_displaying/ad_presenter.dart' as _i15;
import 'dart:async' as _i16;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adModule, this._serviceManagerModule, this._powerModule,
      this._permissionModule, this._gpsModule);

  final _i2.AdModule _adModule;

  final _i3.ServiceManagerModule _serviceManagerModule;

  final _i4.PowerModule _powerModule;

  _i5.PowerProvider _singletonPowerProvider;

  final _i6.PermissionModule _permissionModule;

  _i7.PermissionDebugger _singletonPermissionDebugger;

  _i8.PermissionController _singletonPermissionController;

  _i9.ServiceManager _singletonServiceManager;

  final _i10.GpsModule _gpsModule;

  _i11.GpsController _singletonGpsController;

  _i12.ConfigFactory _singletonConfigFactory;

  _i12.Config _singletonConfig;

  _i13.AdRepository _singletonAdRepository;

  _i14.AdScheduler _singletonAdScheduler;

  _i15.AdPresenter _singletonAdPresenter;

  static _i16.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i4.PowerModule powerModule,
      _i6.PermissionModule permissionModule,
      _i3.ServiceManagerModule serviceManagerModule,
      _i10.GpsModule gpsModule) async {
    final injector = DI$Injector._(adModule, serviceManagerModule, powerModule,
        permissionModule, gpsModule);

    return injector;
  }

  _i15.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(_createAdScheduler());
  _i14.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(), _createAdRepository(), _createConfig());
  _i9.ServiceManager _createServiceManager() =>
      _singletonServiceManager ??= _serviceManagerModule.serviceManager(
          _createPowerProvider(), _createPermissionController());
  _i5.PowerProvider _createPowerProvider() =>
      _singletonPowerProvider ??= _powerModule.powerProvider();
  _i8.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController(_createPermissionDebugger());
  _i7.PermissionDebugger _createPermissionDebugger() =>
      _singletonPermissionDebugger ??= _permissionModule.permissionDebugger();
  _i13.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository(
          _createServiceManager(), _createGpsController(), _createConfig());
  _i11.GpsController _createGpsController() => _singletonGpsController ??=
      _gpsModule.gpsController(_createServiceManager());
  _i12.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i12.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  @override
  _i15.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i14.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i13.AdRepository get adRepository => _createAdRepository();
  @override
  _i12.Config get config => _createConfig();
  @override
  _i5.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i8.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i7.PermissionDebugger get permissionDebugger => _createPermissionDebugger();
  @override
  _i9.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i11.GpsController get gpsController => _createGpsController();
}
