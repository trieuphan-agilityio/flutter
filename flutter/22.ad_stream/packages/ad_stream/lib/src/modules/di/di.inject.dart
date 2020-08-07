import 'di.dart' as _i1;
import '../ad/ad_module.dart' as _i2;
import '../service_manager/service_manager_module.dart' as _i3;
import '../power/power_module.dart' as _i4;
import '../power/power_provider.dart' as _i5;
import '../permission/permission_module.dart' as _i6;
import '../permission/permission_controller.dart' as _i7;
import '../service_manager/service_manager.dart' as _i8;
import '../ad/ad_repository.dart' as _i9;
import '../../base/config.dart' as _i10;
import '../ad/ad_scheduler.dart' as _i11;
import '../../features/ad_displaying/ad_presenter.dart' as _i12;
import '../gps/gps_module.dart' as _i13;
import '../gps/gps_controller.dart' as _i14;
import 'dart:async' as _i15;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adModule, this._serviceManagerModule, this._powerModule,
      this._permissionModule, this._gpsModule);

  final _i2.AdModule _adModule;

  final _i3.ServiceManagerModule _serviceManagerModule;

  final _i4.PowerModule _powerModule;

  _i5.PowerProvider _singletonPowerProvider;

  final _i6.PermissionModule _permissionModule;

  _i7.PermissionController _singletonPermissionController;

  _i8.ServiceManager _singletonServiceManager;

  _i9.AdRepository _singletonAdRepository;

  _i10.ConfigFactory _singletonConfigFactory;

  _i10.Config _singletonConfig;

  _i11.AdScheduler _singletonAdScheduler;

  _i12.AdPresenter _singletonAdPresenter;

  final _i13.GpsModule _gpsModule;

  _i14.GpsController _singletonGpsController;

  static _i15.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i4.PowerModule powerModule,
      _i6.PermissionModule permissionModule,
      _i3.ServiceManagerModule serviceManagerModule,
      _i13.GpsModule gpsModule) async {
    final injector = DI$Injector._(adModule, serviceManagerModule, powerModule,
        permissionModule, gpsModule);

    return injector;
  }

  _i12.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(_createAdScheduler());
  _i11.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(), _createAdRepository(), _createConfig());
  _i8.ServiceManager _createServiceManager() =>
      _singletonServiceManager ??= _serviceManagerModule.serviceManager(
          _createPowerProvider(), _createPermissionController());
  _i5.PowerProvider _createPowerProvider() =>
      _singletonPowerProvider ??= _powerModule.powerProvider();
  _i7.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController();
  _i9.AdRepository _createAdRepository() => _singletonAdRepository ??=
      _adModule.adRepository(_createServiceManager());
  _i10.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i10.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  _i14.GpsController _createGpsController() => _singletonGpsController ??=
      _gpsModule.gpsController(_createServiceManager());
  @override
  _i12.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i11.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i9.AdRepository get adRepository => _createAdRepository();
  @override
  _i10.Config get config => _createConfig();
  @override
  _i5.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i7.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i8.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i14.GpsController get gpsController => _createGpsController();
}
