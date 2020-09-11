import 'di.dart' as _i1;
import '../config/config_module.dart' as _i2;
import '../config/config_provider.dart' as _i3;
import '../config/ad_presenter_config.dart' as _i4;
import '../ad/ad_module.dart' as _i5;
import '../service_manager/service_manager_module.dart' as _i6;
import '../power/power_module.dart' as _i7;
import '../power/debugger/power_debugger.dart' as _i8;
import '../power/power_provider.dart' as _i9;
import '../permission/permission_module.dart' as _i10;
import '../storage/storage_module.dart' as _i11;
import 'package:shared_preferences/shared_preferences.dart' as _i12;
import '../storage/pref_storage.dart' as _i13;
import '../permission/debugger/permission_debugger.dart' as _i14;
import '../permission/permission_controller.dart' as _i15;
import '../service_manager/service_manager.dart' as _i16;
import '../ad/ad_api_client.dart' as _i17;
import '../common/common_module.dart' as _i18;
import '../common/file_url_resolver.dart' as _i19;
import '../common/file_path_resolver.dart' as _i20;
import '../config/config.dart' as _i21;
import '../ad/creative_downloader.dart' as _i22;
import '../config/ad_repository_config.dart' as _i23;
import '../gps/gps_module.dart' as _i24;
import '../gps/gps_controller.dart' as _i25;
import '../gps/debugger/gps_debugger.dart' as _i26;
import '../config/gps_config.dart' as _i27;
import '../gps/gps_options_provider.dart' as _i28;
import '../ad/debugger/ad_repository_debugger.dart' as _i29;
import '../ad/ad_repository.dart' as _i30;
import '../config/ad_scheduler_config.dart' as _i31;
import '../config/ad_config.dart' as _i32;
import '../on_trip/on_trip_module.dart' as _i33;
import '../on_trip/gender_detector.dart' as _i34;
import '../on_trip/age_detector.dart' as _i35;
import '../gps/movement_detector.dart' as _i36;
import '../config/camera_config.dart' as _i37;
import '../on_trip/debugger/camera_debugger.dart' as _i38;
import '../on_trip/camera_controller.dart' as _i39;
import '../on_trip/face_detector.dart' as _i40;
import '../on_trip/trip_detector.dart' as _i41;
import '../config/mic_config.dart' as _i42;
import '../on_trip/mic_controller.dart' as _i43;
import '../on_trip/speech_to_text.dart' as _i44;
import '../on_trip/keyword_detector.dart' as _i45;
import '../config/area_config.dart' as _i46;
import '../on_trip/area_detector.dart' as _i47;
import '../ad/targeting_value_collector.dart' as _i48;
import '../ad/ad_scheduler.dart' as _i49;
import '../ad/ad_presenter.dart' as _i50;
import '../config/downloader_config.dart' as _i51;
import 'dart:async' as _i52;

class DI$Injector implements _i1.DI {
  DI$Injector._(
      this._configModule,
      this._adModule,
      this._serviceManagerModule,
      this._powerModule,
      this._permissionModule,
      this._storageModule,
      this._commonModule,
      this._gpsModule,
      this._onTripModule);

  final _i2.ConfigModule _configModule;

  _i3.ConfigProvider _singletonConfigProvider;

  _i4.AdPresenterConfigProvider _singletonAdPresenterConfigProvider;

  final _i5.AdModule _adModule;

  final _i6.ServiceManagerModule _serviceManagerModule;

  final _i7.PowerModule _powerModule;

  _i8.PowerDebugger _singletonPowerDebugger;

  _i9.PowerProvider _singletonPowerProvider;

  final _i10.PermissionModule _permissionModule;

  final _i11.StorageModule _storageModule;

  _i12.SharedPreferences _sharedPreferences;

  _i13.PrefStoreWriting _singletonPrefStoreWriting;

  _i14.PermissionDebugger _singletonPermissionDebugger;

  _i15.PermissionController _singletonPermissionController;

  _i16.ServiceManager _singletonServiceManager;

  _i17.AdApiClient _singletonAdApiClient;

  final _i18.CommonModule _commonModule;

  _i19.FileUrlResolver _singletonFileUrlResolver;

  _i20.FilePathResolver _singletonFilePathResolver;

  _i21.Config _config;

  _i21.ConfigFactory _singletonConfigFactory;

  _i22.CreativeDownloader _singletonCreativeDownloader;

  _i23.AdRepositoryConfigProvider _singletonAdRepositoryConfigProvider;

  final _i24.GpsModule _gpsModule;

  _i25.GpsController _gpsController;

  _i26.GpsDebugger _singletonGpsDebugger;

  _i27.GpsConfigProvider _singletonGpsConfigProvider;

  _i28.GpsOptionsProvider _singletonGpsOptionsProvider;

  _i29.AdRepositoryDebugger _singletonAdRepositoryDebugger;

  _i30.AdRepository _singletonAdRepository;

  _i31.AdSchedulerConfigProvider _singletonAdSchedulerConfigProvider;

  _i32.AdConfigProvider _singletonAdConfigProvider;

  final _i33.OnTripModule _onTripModule;

  _i34.GenderDetector _singletonGenderDetector;

  _i35.AgeDetector _singletonAgeDetector;

  _i36.MovementDetector _singletonMovementDetector;

  _i37.CameraConfigProvider _singletonCameraConfigProvider;

  _i38.CameraDebugger _singletonCameraDebugger;

  _i39.CameraController _singletonCameraController;

  _i40.FaceDetector _singletonFaceDetector;

  _i41.TripDetector _singletonTripDetector;

  _i42.MicConfigProvider _singletonMicConfigProvider;

  _i43.MicController _singletonMicController;

  _i44.SpeechToText _singletonSpeechToText;

  _i45.KeywordDetector _singletonKeywordDetector;

  _i46.AreaConfigProvider _singletonAreaConfigProvider;

  _i47.AreaDetector _singletonAreaDetector;

  _i48.TargetingValueCollector _singletonTargetingValueCollector;

  _i49.AdScheduler _singletonAdScheduler;

  _i50.AdPresenter _singletonAdPresenter;

  _i51.DownloaderConfigProvider _singletonDownloaderConfigProvider;

  _i13.PrefStoreReading _singletonPrefStoreReading;

  static _i52.Future<_i1.DI> create(
      _i5.AdModule adModule,
      _i2.ConfigModule configModule,
      _i18.CommonModule commonModule,
      _i11.StorageModule storageModule,
      _i7.PowerModule powerModule,
      _i10.PermissionModule permissionModule,
      _i6.ServiceManagerModule serviceManagerModule,
      _i24.GpsModule gpsModule,
      _i33.OnTripModule onTripModule) async {
    final injector = DI$Injector._(
        configModule,
        adModule,
        serviceManagerModule,
        powerModule,
        permissionModule,
        storageModule,
        commonModule,
        gpsModule,
        onTripModule);
    injector._sharedPreferences =
        await injector._storageModule.sharedPreferences();
    injector._config =
        await injector._adModule.config(injector._createConfigFactory());
    injector._gpsController = await injector._gpsModule.gpsController(
        injector._createServiceManager(),
        injector._createPermissionDebugger(),
        injector._createGpsDebugger(),
        injector._createGpsOptionsProvider());
    return injector;
  }

  _i4.AdPresenterConfigProvider _createAdPresenterConfigProvider() =>
      _singletonAdPresenterConfigProvider ??=
          _configModule.adPresenterConfigProvider(_createConfigProvider());
  _i3.ConfigProvider _createConfigProvider() =>
      _singletonConfigProvider ??= _configModule.configProvider();
  _i50.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(
          _createServiceManager(),
          _createAdScheduler(),
          _createAdPresenterConfigProvider(),
          _createAdConfigProvider());
  _i16.ServiceManager _createServiceManager() =>
      _singletonServiceManager ??= _serviceManagerModule.serviceManager(
          _createPowerProvider(), _createPermissionController());
  _i9.PowerProvider _createPowerProvider() => _singletonPowerProvider ??=
      _powerModule.powerProvider(_createPowerDebugger());
  _i8.PowerDebugger _createPowerDebugger() =>
      _singletonPowerDebugger ??= _powerModule.powerDebugger();
  _i15.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController(_createPermissionDebugger());
  _i14.PermissionDebugger _createPermissionDebugger() =>
      _singletonPermissionDebugger ??=
          _permissionModule.permissionDebugger(_createPrefStoreWriting());
  _i13.PrefStoreWriting _createPrefStoreWriting() =>
      _singletonPrefStoreWriting ??=
          _storageModule.prefStoreWriting(_createSharedPreferences());
  _i12.SharedPreferences _createSharedPreferences() => _sharedPreferences;
  _i49.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(),
          _createAdRepository(),
          _createAdSchedulerConfigProvider(),
          _createAdConfigProvider(),
          _createTargetingValueCollector());
  _i30.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository(
          _createAdApiClient(),
          _createCreativeDownloader(),
          _createAdRepositoryConfigProvider(),
          _createServiceManager(),
          _createGpsController(),
          _createAdRepositoryDebugger());
  _i17.AdApiClient _createAdApiClient() =>
      _singletonAdApiClient ??= _adModule.adApiClient();
  _i22.CreativeDownloader _createCreativeDownloader() =>
      _singletonCreativeDownloader ??= _adModule.creativeDownloader(
          _createFileUrlResolver(), _createFilePathResolver(), _createConfig());
  _i19.FileUrlResolver _createFileUrlResolver() =>
      _singletonFileUrlResolver ??= _commonModule.fileUrlResolver();
  _i20.FilePathResolver _createFilePathResolver() =>
      _singletonFilePathResolver ??= _commonModule.filePathResolver();
  _i21.Config _createConfig() => _config;
  _i21.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  _i23.AdRepositoryConfigProvider _createAdRepositoryConfigProvider() =>
      _singletonAdRepositoryConfigProvider ??=
          _configModule.adRepositoryConfigProvider(_createConfigProvider());
  _i25.GpsController _createGpsController() => _gpsController;
  _i26.GpsDebugger _createGpsDebugger() =>
      _singletonGpsDebugger ??= _gpsModule.gpsDebugger();
  _i28.GpsOptionsProvider _createGpsOptionsProvider() =>
      _singletonGpsOptionsProvider ??=
          _gpsModule.gpsOptionsProvider(_createGpsConfigProvider());
  _i27.GpsConfigProvider _createGpsConfigProvider() =>
      _singletonGpsConfigProvider ??=
          _configModule.gpsConfigProvider(_createConfigProvider());
  _i29.AdRepositoryDebugger _createAdRepositoryDebugger() =>
      _singletonAdRepositoryDebugger ??= _adModule.adRepositoryDebugger();
  _i31.AdSchedulerConfigProvider _createAdSchedulerConfigProvider() =>
      _singletonAdSchedulerConfigProvider ??=
          _configModule.adSchedulerConfigProvider(_createConfigProvider());
  _i32.AdConfigProvider _createAdConfigProvider() =>
      _singletonAdConfigProvider ??=
          _configModule.adConfigProvider(_createConfigProvider());
  _i48.TargetingValueCollector _createTargetingValueCollector() =>
      _singletonTargetingValueCollector ??= _adModule.targetingValueCollector(
          _createServiceManager(),
          _createGenderDetector(),
          _createAgeDetector(),
          _createTripDetector(),
          _createKeywordDetector(),
          _createAreaDetector());
  _i34.GenderDetector _createGenderDetector() =>
      _singletonGenderDetector ??= _onTripModule.genderDetector();
  _i35.AgeDetector _createAgeDetector() =>
      _singletonAgeDetector ??= _onTripModule.ageDetector();
  _i41.TripDetector _createTripDetector() =>
      _singletonTripDetector ??= _onTripModule.tripDetector(
          _createServiceManager(),
          _createMovementDetector(),
          _createFaceDetector(),
          _createGpsOptionsProvider());
  _i36.MovementDetector _createMovementDetector() =>
      _singletonMovementDetector ??= _gpsModule.movementDetector(
          _createServiceManager(), _createGpsController());
  _i40.FaceDetector _createFaceDetector() =>
      _singletonFaceDetector ??= _onTripModule.faceDetector(
          _createMovementDetector(), _createCameraController());
  _i39.CameraController _createCameraController() =>
      _singletonCameraController ??= _onTripModule.cameraController(
          _createCameraConfigProvider(), _createCameraDebugger());
  _i37.CameraConfigProvider _createCameraConfigProvider() =>
      _singletonCameraConfigProvider ??=
          _configModule.cameraConfigProvider(_createConfigProvider());
  _i38.CameraDebugger _createCameraDebugger() =>
      _singletonCameraDebugger ??= _onTripModule.cameraDebugger();
  _i45.KeywordDetector _createKeywordDetector() =>
      _singletonKeywordDetector ??= _onTripModule.keywordDetector(
          _createTripDetector(), _createAdRepository(), _createSpeechToText());
  _i44.SpeechToText _createSpeechToText() => _singletonSpeechToText ??=
      _onTripModule.speechToText(_createMicController());
  _i43.MicController _createMicController() => _singletonMicController ??=
      _onTripModule.micController(_createMicConfigProvider());
  _i42.MicConfigProvider _createMicConfigProvider() =>
      _singletonMicConfigProvider ??=
          _configModule.micConfigProvider(_createConfigProvider());
  _i47.AreaDetector _createAreaDetector() =>
      _singletonAreaDetector ??= _onTripModule.areaDetector(
          _createGpsController(), _createAreaConfigProvider());
  _i46.AreaConfigProvider _createAreaConfigProvider() =>
      _singletonAreaConfigProvider ??=
          _configModule.areaConfigProvider(_createConfigProvider());
  _i51.DownloaderConfigProvider _createDownloaderConfigProvider() =>
      _singletonDownloaderConfigProvider ??=
          _configModule.downloaderConfigProvider(_createConfigProvider());
  _i13.PrefStoreReading _createPrefStoreReading() =>
      _singletonPrefStoreReading ??=
          _storageModule.prefStoreReading(_createPrefStoreWriting());
  @override
  _i4.AdPresenterConfigProvider get config =>
      _createAdPresenterConfigProvider();
  @override
  _i50.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i49.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i30.AdRepository get adRepository => _createAdRepository();
  @override
  _i22.CreativeDownloader get creativeDownloader => _createCreativeDownloader();
  @override
  _i3.ConfigProvider get configProvider => _createConfigProvider();
  @override
  _i32.AdConfigProvider get adConfigProvider => _createAdConfigProvider();
  @override
  _i4.AdPresenterConfigProvider get adPresenterConfigProvider =>
      _createAdPresenterConfigProvider();
  @override
  _i23.AdRepositoryConfigProvider get adRepositoryConfigProvider =>
      _createAdRepositoryConfigProvider();
  @override
  _i31.AdSchedulerConfigProvider get adSchedulerConfigProvider =>
      _createAdSchedulerConfigProvider();
  @override
  _i46.AreaConfigProvider get areaConfigProvider => _createAreaConfigProvider();
  @override
  _i37.CameraConfigProvider get cameraConfigProvider =>
      _createCameraConfigProvider();
  @override
  _i51.DownloaderConfigProvider get downloaderConfigProvider =>
      _createDownloaderConfigProvider();
  @override
  _i27.GpsConfigProvider get gpsConfigProvider => _createGpsConfigProvider();
  @override
  _i42.MicConfigProvider get micConfigProvider => _createMicConfigProvider();
  @override
  _i19.FileUrlResolver get fileUrlResolver => _createFileUrlResolver();
  @override
  _i20.FilePathResolver get filePathResolver => _createFilePathResolver();
  @override
  _i13.PrefStoreReading get prefStoreReading => _createPrefStoreReading();
  @override
  _i13.PrefStoreWriting get prefStoreWriting => _createPrefStoreWriting();
  @override
  _i9.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i8.PowerDebugger get powerDebugger => _createPowerDebugger();
  @override
  _i15.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i14.PermissionDebugger get permissionDebugger => _createPermissionDebugger();
  @override
  _i16.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i25.GpsController get gpsController => _createGpsController();
  @override
  _i26.GpsDebugger get gpsDebugger => _createGpsDebugger();
  @override
  _i28.GpsOptionsProvider get gpsOptionsProvider => _createGpsOptionsProvider();
  @override
  _i36.MovementDetector get movementDetector => _createMovementDetector();
  @override
  _i41.TripDetector get tripDetector => _createTripDetector();
  @override
  _i39.CameraController get cameraController => _createCameraController();
  @override
  _i38.CameraDebugger get cameraDebugger => _createCameraDebugger();
  @override
  _i43.MicController get micController => _createMicController();
  @override
  _i44.SpeechToText get speechToText => _createSpeechToText();
  @override
  _i45.KeywordDetector get keywordDetector => _createKeywordDetector();
  @override
  _i40.FaceDetector get faceDetector => _createFaceDetector();
  @override
  _i35.AgeDetector get ageDetector => _createAgeDetector();
  @override
  _i34.GenderDetector get genderDetector => _createGenderDetector();
  @override
  _i47.AreaDetector get areaDetector => _createAreaDetector();
}
