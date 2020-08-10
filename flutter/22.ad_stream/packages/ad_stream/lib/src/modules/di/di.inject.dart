import 'di.dart' as _i1;
import '../ad/ad_module.dart' as _i2;
import '../service_manager/service_manager_module.dart' as _i3;
import '../power/power_module.dart' as _i4;
import '../power/debugger/power_debugger.dart' as _i5;
import '../power/power_provider.dart' as _i6;
import '../permission/permission_module.dart' as _i7;
import '../permission/debugger/permission_debugger.dart' as _i8;
import '../permission/permission_controller.dart' as _i9;
import '../service_manager/service_manager.dart' as _i10;
import '../gps/gps_module.dart' as _i11;
import '../gps/gps_controller.dart' as _i12;
import '../../base/config.dart' as _i13;
import '../ad/ad_repository.dart' as _i14;
import '../ad/ad_scheduler.dart' as _i15;
import '../../features/ad_displaying/ad_presenter.dart' as _i16;
import 'dart:async' as _i17;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adModule, this._serviceManagerModule, this._powerModule,
      this._permissionModule, this._gpsModule);

  final _i2.AdModule _adModule;

  final _i3.ServiceManagerModule _serviceManagerModule;

  final _i4.PowerModule _powerModule;

  _i5.PowerDebugger _singletonPowerDebugger;

  _i6.PowerProvider _singletonPowerProvider;

  final _i7.PermissionModule _permissionModule;

  _i8.PermissionDebugger _singletonPermissionDebugger;

  _i9.PermissionController _singletonPermissionController;

  _i10.ServiceManager _singletonServiceManager;

  final _i11.GpsModule _gpsModule;

  _i12.GpsController _singletonGpsController;

  _i13.ConfigFactory _singletonConfigFactory;

  _i13.Config _singletonConfig;

  _i14.AdRepository _singletonAdRepository;

  _i15.AdScheduler _singletonAdScheduler;

  _i16.AdPresenter _singletonAdPresenter;

  static _i17.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i4.PowerModule powerModule,
      _i7.PermissionModule permissionModule,
      _i3.ServiceManagerModule serviceManagerModule,
      _i11.GpsModule gpsModule) async {
    final injector = DI$Injector._(adModule, serviceManagerModule, powerModule,
        permissionModule, gpsModule);

    return injector;
  }

  _i16.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(_createAdScheduler());
  _i15.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(), _createAdRepository(), _createConfig());
  _i10.ServiceManager _createServiceManager() =>
      _singletonServiceManager ??= _serviceManagerModule.serviceManager(
          _createPowerProvider(), _createPermissionController());
  _i6.PowerProvider _createPowerProvider() => _singletonPowerProvider ??=
      _powerModule.powerProvider(_createPowerDebugger());
  _i5.PowerDebugger _createPowerDebugger() =>
      _singletonPowerDebugger ??= _powerModule.powerDebugger();
  _i9.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController(_createPermissionDebugger());
  _i8.PermissionDebugger _createPermissionDebugger() =>
      _singletonPermissionDebugger ??= _permissionModule.permissionDebugger();
  _i14.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository(
          _createServiceManager(), _createGpsController(), _createConfig());
  _i12.GpsController _createGpsController() => _singletonGpsController ??=
      _gpsModule.gpsController(_createServiceManager());
  _i13.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i13.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  @override
  _i16.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i15.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i14.AdRepository get adRepository => _createAdRepository();
  @override
  _i13.Config get config => _createConfig();
  @override
  _i6.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i9.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i8.PermissionDebugger get permissionDebugger => _createPermissionDebugger();
  @override
  _i10.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i12.GpsController get gpsController => _createGpsController();
}
