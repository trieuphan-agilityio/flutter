import 'di.dart' as _i1;
import '../ad/ad_services.dart' as _i2;
import '../ad/ad_repository.dart' as _i3;
import '../../base/config.dart' as _i4;
import '../ad/ad_scheduler.dart' as _i5;
import '../../features/ad_displaying/ad_presenter.dart' as _i6;
import '../power/power_services.dart' as _i7;
import '../power/power_provider.dart' as _i8;
import '../permission/permission_services.dart' as _i9;
import '../permission/permission_controller.dart' as _i10;
import '../supervisor/supervisor_services.dart' as _i11;
import '../gps/gps_services.dart' as _i12;
import '../gps/gps_controller.dart' as _i13;
import '../supervisor/supervisor.dart' as _i14;
import 'dart:async' as _i15;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adServices, this._powerServices, this._permissionServices,
      this._supervisorServices, this._gpsServices);

  final _i2.AdServices _adServices;

  _i3.AdRepository _singletonAdRepository;

  _i4.ConfigFactory _singletonConfigFactory;

  _i4.Config _singletonConfig;

  _i5.AdScheduler _singletonAdScheduler;

  _i6.AdPresentable _singletonAdPresentable;

  final _i7.PowerServices _powerServices;

  _i8.PowerProvider _singletonPowerProvider;

  final _i9.PermissionServices _permissionServices;

  _i10.PermissionController _singletonPermissionController;

  final _i11.SupervisorServices _supervisorServices;

  final _i12.GpsServices _gpsServices;

  _i13.GpsController _singletonGpsController;

  _i14.Supervisor _singletonSupervisor;

  static _i15.Future<_i1.DI> create(
      _i2.AdServices adServices,
      _i7.PowerServices powerServices,
      _i9.PermissionServices permissionServices,
      _i11.SupervisorServices supervisorServices,
      _i12.GpsServices gpsServices) async {
    final injector = DI$Injector._(adServices, powerServices,
        permissionServices, supervisorServices, gpsServices);

    return injector;
  }

  _i6.AdPresentable _createAdPresentable() =>
      _singletonAdPresentable ??= _adServices.adPresenter(_createAdScheduler());
  _i5.AdScheduler _createAdScheduler() => _singletonAdScheduler ??=
      _adServices.adScheduler(_createAdRepository(), _createConfig());
  _i3.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adServices.adRepository();
  _i4.Config _createConfig() =>
      _singletonConfig ??= _adServices.config(_createConfigFactory());
  _i4.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adServices.configFactory();
  _i8.PowerProvider _createPowerProvider() =>
      _singletonPowerProvider ??= _powerServices.powerProvider();
  _i10.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionServices.permissionController();
  _i14.Supervisor _createSupervisor() =>
      _singletonSupervisor ??= _supervisorServices.supervisor(
          _createPowerProvider(),
          _createPermissionController(),
          _createGpsController(),
          _createAdScheduler());
  _i13.GpsController _createGpsController() =>
      _singletonGpsController ??= _gpsServices.gpsController();
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
