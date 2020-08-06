import 'di.dart' as _i1;
import '../ad/ad_module.dart' as _i2;
import '../ad/ad_repository.dart' as _i3;
import '../../base/config.dart' as _i4;
import '../ad/ad_scheduler.dart' as _i5;
import '../../features/ad_displaying/ad_presenter.dart' as _i6;
import '../power/power_module.dart' as _i7;
import '../power/power_provider.dart' as _i8;
import '../permission/permission_module.dart' as _i9;
import '../permission/permission_controller.dart' as _i10;
import '../supervisor/supervisor_module.dart' as _i11;
import '../gps/gps_module.dart' as _i12;
import '../gps/gps_controller.dart' as _i13;
import '../supervisor/supervisor.dart' as _i14;
import 'dart:async' as _i15;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adModule, this._powerModule, this._permissionModule,
      this._supervisorModule, this._gpsModule);

  final _i2.AdModule _adModule;

  _i3.AdRepository _singletonAdRepository;

  _i4.ConfigFactory _singletonConfigFactory;

  _i4.Config _singletonConfig;

  _i5.AdScheduler _singletonAdScheduler;

  _i6.AdPresentable _singletonAdPresentable;

  final _i7.PowerModule _powerModule;

  _i8.PowerProvider _singletonPowerProvider;

  final _i9.PermissionModule _permissionModule;

  _i10.PermissionController _singletonPermissionController;

  final _i11.SupervisorModule _supervisorModule;

  final _i12.GpsModule _gpsModule;

  _i13.GpsController _singletonGpsController;

  _i14.Supervisor _singletonSupervisor;

  static _i15.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i7.PowerModule powerModule,
      _i9.PermissionModule permissionModule,
      _i11.SupervisorModule supervisorModule,
      _i12.GpsModule gpsModule) async {
    final injector = DI$Injector._(
        adModule, powerModule, permissionModule, supervisorModule, gpsModule);

    return injector;
  }

  _i6.AdPresentable _createAdPresentable() =>
      _singletonAdPresentable ??= _adModule.adPresenter(_createAdScheduler());
  _i5.AdScheduler _createAdScheduler() => _singletonAdScheduler ??=
      _adModule.adScheduler(_createAdRepository(), _createConfig());
  _i3.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository();
  _i4.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i4.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  _i8.PowerProvider _createPowerProvider() =>
      _singletonPowerProvider ??= _powerModule.powerProvider();
  _i10.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController();
  _i14.Supervisor _createSupervisor() =>
      _singletonSupervisor ??= _supervisorModule.supervisor(
          _createPowerProvider(),
          _createPermissionController(),
          _createGpsController(),
          _createAdScheduler(),
          _createAdRepository());
  _i13.GpsController _createGpsController() =>
      _singletonGpsController ??= _gpsModule.gpsController();
  @override
  _i6.AdPresentable get adPresenter => _createAdPresentable();
  @override
  _i5.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i3.AdRepository get adRepository => _createAdRepository();
  @override
  _i4.Config get config => _createConfig();
  @override
  _i8.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i10.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i14.Supervisor get supervisor => _createSupervisor();
  @override
  _i13.GpsController get gpsController => _createGpsController();
}
