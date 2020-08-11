import 'di.dart' as _i1;
import '../ad/ad_module.dart' as _i2;
import '../../base/config.dart' as _i3;
import '../service_manager/service_manager_module.dart' as _i4;
import '../power/power_module.dart' as _i5;
import '../power/debugger/power_debugger.dart' as _i6;
import '../power/power_provider.dart' as _i7;
import '../permission/permission_module.dart' as _i8;
import '../permission/debugger/permission_debugger.dart' as _i9;
import '../permission/permission_controller.dart' as _i10;
import '../service_manager/service_manager.dart' as _i11;
import '../common/common_module.dart' as _i12;
import '../common/file_url_resolver.dart' as _i13;
import '../common/file_path_resolver.dart' as _i14;
import '../ad/creative_downloader.dart' as _i15;
import '../gps/gps_module.dart' as _i16;
import '../gps/gps_controller.dart' as _i17;
import '../ad/ad_repository.dart' as _i18;
import '../ad/ad_scheduler.dart' as _i19;
import '../../features/ad_displaying/ad_presenter.dart' as _i20;
import 'dart:async' as _i21;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adModule, this._serviceManagerModule, this._powerModule,
      this._permissionModule, this._commonModule, this._gpsModule);

  final _i2.AdModule _adModule;

  _i3.ConfigFactory _singletonConfigFactory;

  _i3.Config _singletonConfig;

  final _i4.ServiceManagerModule _serviceManagerModule;

  final _i5.PowerModule _powerModule;

  _i6.PowerDebugger _singletonPowerDebugger;

  _i7.PowerProvider _singletonPowerProvider;

  final _i8.PermissionModule _permissionModule;

  _i9.PermissionDebugger _singletonPermissionDebugger;

  _i10.PermissionController _singletonPermissionController;

  _i11.ServiceManager _singletonServiceManager;

  final _i12.CommonModule _commonModule;

  _i13.FileUrlResolver _singletonFileUrlResolver;

  _i14.FilePathResolver _singletonFilePathResolver;

  _i15.CreativeDownloader _singletonCreativeDownloader;

  final _i16.GpsModule _gpsModule;

  _i17.GpsController _singletonGpsController;

  _i18.AdRepository _singletonAdRepository;

  _i19.AdScheduler _singletonAdScheduler;

  _i20.AdPresenter _singletonAdPresenter;

  static _i21.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i12.CommonModule commonModule,
      _i5.PowerModule powerModule,
      _i8.PermissionModule permissionModule,
      _i4.ServiceManagerModule serviceManagerModule,
      _i16.GpsModule gpsModule) async {
    final injector = DI$Injector._(adModule, serviceManagerModule, powerModule,
        permissionModule, commonModule, gpsModule);

    return injector;
  }

  _i3.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i3.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  _i20.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(_createAdScheduler());
  _i19.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(), _createAdRepository(), _createConfig());
  _i11.ServiceManager _createServiceManager() =>
      _singletonServiceManager ??= _serviceManagerModule.serviceManager(
          _createPowerProvider(), _createPermissionController());
  _i7.PowerProvider _createPowerProvider() => _singletonPowerProvider ??=
      _powerModule.powerProvider(_createPowerDebugger());
  _i6.PowerDebugger _createPowerDebugger() =>
      _singletonPowerDebugger ??= _powerModule.powerDebugger();
  _i10.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController(_createPermissionDebugger());
  _i9.PermissionDebugger _createPermissionDebugger() =>
      _singletonPermissionDebugger ??= _permissionModule.permissionDebugger();
  _i18.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository(
          _createCreativeDownloader(),
          _createConfig(),
          _createServiceManager(),
          _createGpsController());
  _i15.CreativeDownloader _createCreativeDownloader() =>
      _singletonCreativeDownloader ??= _adModule.creativeDownloader(
          _createFileUrlResolver(), _createFilePathResolver(), _createConfig());
  _i13.FileUrlResolver _createFileUrlResolver() => _singletonFileUrlResolver ??=
      _commonModule.fileUrlResolver(_createConfig());
  _i14.FilePathResolver _createFilePathResolver() =>
      _singletonFilePathResolver ??=
          _commonModule.filePathResolver(_createConfig());
  _i17.GpsController _createGpsController() => _singletonGpsController ??=
      _gpsModule.gpsController(_createServiceManager());
  @override
  _i3.Config get config => _createConfig();
  @override
  _i20.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i19.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i18.AdRepository get adRepository => _createAdRepository();
  @override
  _i15.CreativeDownloader get creativeDownloader => _createCreativeDownloader();
  @override
  _i13.FileUrlResolver get fileUrlResolver => _createFileUrlResolver();
  @override
  _i14.FilePathResolver get filePathResolver => _createFilePathResolver();
  @override
  _i7.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i10.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i9.PermissionDebugger get permissionDebugger => _createPermissionDebugger();
  @override
  _i11.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i17.GpsController get gpsController => _createGpsController();
}
