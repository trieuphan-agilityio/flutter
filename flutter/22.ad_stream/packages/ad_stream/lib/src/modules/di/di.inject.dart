import 'di.dart' as _i1;
import '../ad/ad_module.dart' as _i2;
import '../../base/config.dart' as _i3;
import '../service_manager/service_manager_module.dart' as _i4;
import '../power/power_module.dart' as _i5;
import '../power/debugger/power_debugger.dart' as _i6;
import '../power/power_provider.dart' as _i7;
import '../permission/permission_module.dart' as _i8;
import '../storage/storage_module.dart' as _i9;
import 'package:shared_preferences/shared_preferences.dart' as _i10;
import '../storage/pref_storage.dart' as _i11;
import '../permission/debugger/permission_debugger.dart' as _i12;
import '../permission/permission_controller.dart' as _i13;
import '../service_manager/service_manager.dart' as _i14;
import '../ad/ad_api_client.dart' as _i15;
import '../common/common_module.dart' as _i16;
import '../common/file_url_resolver.dart' as _i17;
import '../common/file_path_resolver.dart' as _i18;
import '../ad/creative_downloader.dart' as _i19;
import '../gps/gps_module.dart' as _i20;
import '../gps/debugger/gps_debugger.dart' as _i21;
import '../gps/gps_controller.dart' as _i22;
import '../ad/ad_repository.dart' as _i23;
import '../on_trip/on_trip_module.dart' as _i24;
import '../gps/movement_detector.dart' as _i25;
import '../on_trip/camera_controller.dart' as _i26;
import '../on_trip/face_detector.dart' as _i27;
import '../on_trip/trip_detector.dart' as _i28;
import '../on_trip/gender_detector.dart' as _i29;
import '../on_trip/age_detector.dart' as _i30;
import '../on_trip/mic_controller.dart' as _i31;
import '../on_trip/speech_to_text.dart' as _i32;
import '../on_trip/keyword_detector.dart' as _i33;
import '../on_trip/area_detector.dart' as _i34;
import '../ad/targeting_value_collector.dart' as _i35;
import '../ad/ad_scheduler.dart' as _i36;
import '../ad/ad_presenter.dart' as _i37;
import 'dart:async' as _i38;

class DI$Injector implements _i1.DI {
  DI$Injector._(
      this._adModule,
      this._serviceManagerModule,
      this._powerModule,
      this._permissionModule,
      this._storageModule,
      this._commonModule,
      this._gpsModule,
      this._onTripModule);

  final _i2.AdModule _adModule;

  _i3.ConfigFactory _singletonConfigFactory;

  _i3.Config _singletonConfig;

  final _i4.ServiceManagerModule _serviceManagerModule;

  final _i5.PowerModule _powerModule;

  _i6.PowerDebugger _singletonPowerDebugger;

  _i7.PowerProvider _singletonPowerProvider;

  final _i8.PermissionModule _permissionModule;

  final _i9.StorageModule _storageModule;

  _i10.SharedPreferences _sharedPreferences;

  _i11.PrefStoreWriting _singletonPrefStoreWriting;

  _i12.PermissionDebugger _singletonPermissionDebugger;

  _i13.PermissionController _singletonPermissionController;

  _i14.ServiceManager _singletonServiceManager;

  _i15.AdApiClient _singletonAdApiClient;

  final _i16.CommonModule _commonModule;

  _i17.FileUrlResolver _singletonFileUrlResolver;

  _i18.FilePathResolver _singletonFilePathResolver;

  _i19.CreativeDownloader _singletonCreativeDownloader;

  final _i20.GpsModule _gpsModule;

  _i21.GpsDebugger _singletonGpsDebugger;

  _i22.GpsController _singletonGpsController;

  _i23.AdRepository _singletonAdRepository;

  final _i24.OnTripModule _onTripModule;

  _i25.MovementDetector _singletonMovementDetector;

  _i26.CameraController _singletonCameraController;

  _i27.FaceDetector _singletonFaceDetector;

  _i28.TripDetector _singletonTripDetector;

  _i29.GenderDetector _singletonGenderDetector;

  _i30.AgeDetector _singletonAgeDetector;

  _i31.MicController _singletonMicController;

  _i32.SpeechToText _singletonSpeechToText;

  _i33.KeywordDetector _singletonKeywordDetector;

  _i34.AreaDetector _singletonAreaDetector;

  _i35.TargetingValueCollector _singletonTargetingValueCollector;

  _i36.AdScheduler _singletonAdScheduler;

  _i37.AdPresenter _singletonAdPresenter;

  _i11.PrefStoreReading _singletonPrefStoreReading;

  static _i38.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i16.CommonModule commonModule,
      _i9.StorageModule storageModule,
      _i5.PowerModule powerModule,
      _i8.PermissionModule permissionModule,
      _i4.ServiceManagerModule serviceManagerModule,
      _i20.GpsModule gpsModule,
      _i24.OnTripModule onTripModule) async {
    final injector = DI$Injector._(adModule, serviceManagerModule, powerModule,
        permissionModule, storageModule, commonModule, gpsModule, onTripModule);
    injector._sharedPreferences =
        await injector._storageModule.sharedPreferences();
    return injector;
  }

  _i3.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i3.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  _i37.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(
          _createServiceManager(), _createAdScheduler(), _createConfig());
  _i14.ServiceManager _createServiceManager() =>
      _singletonServiceManager ??= _serviceManagerModule.serviceManager(
          _createPowerProvider(), _createPermissionController());
  _i7.PowerProvider _createPowerProvider() => _singletonPowerProvider ??=
      _powerModule.powerProvider(_createPowerDebugger());
  _i6.PowerDebugger _createPowerDebugger() =>
      _singletonPowerDebugger ??= _powerModule.powerDebugger();
  _i13.PermissionController _createPermissionController() =>
      _singletonPermissionController ??=
          _permissionModule.permissionController(_createPermissionDebugger());
  _i12.PermissionDebugger _createPermissionDebugger() =>
      _singletonPermissionDebugger ??=
          _permissionModule.permissionDebugger(_createPrefStoreWriting());
  _i11.PrefStoreWriting _createPrefStoreWriting() =>
      _singletonPrefStoreWriting ??=
          _storageModule.prefStoreWriting(_createSharedPreferences());
  _i10.SharedPreferences _createSharedPreferences() => _sharedPreferences;
  _i36.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(),
          _createAdRepository(),
          _createConfig(),
          _createTargetingValueCollector());
  _i23.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository(
          _createAdApiClient(),
          _createCreativeDownloader(),
          _createConfig(),
          _createServiceManager(),
          _createGpsController());
  _i15.AdApiClient _createAdApiClient() =>
      _singletonAdApiClient ??= _adModule.adApiClient();
  _i19.CreativeDownloader _createCreativeDownloader() =>
      _singletonCreativeDownloader ??= _adModule.creativeDownloader(
          _createFileUrlResolver(), _createFilePathResolver(), _createConfig());
  _i17.FileUrlResolver _createFileUrlResolver() => _singletonFileUrlResolver ??=
      _commonModule.fileUrlResolver(_createConfig());
  _i18.FilePathResolver _createFilePathResolver() =>
      _singletonFilePathResolver ??=
          _commonModule.filePathResolver(_createConfig());
  _i22.GpsController _createGpsController() =>
      _singletonGpsController ??= _gpsModule.gpsController(
          _createServiceManager(), _createGpsDebugger(), _createConfig());
  _i21.GpsDebugger _createGpsDebugger() =>
      _singletonGpsDebugger ??= _gpsModule.gpsDebugger();
  _i35.TargetingValueCollector _createTargetingValueCollector() =>
      _singletonTargetingValueCollector ??= _adModule.targetingValueCollector(
          _createServiceManager(),
          _createGenderDetector(),
          _createAgeDetector(),
          _createKeywordDetector(),
          _createAreaDetector());
  _i29.GenderDetector _createGenderDetector() =>
      _singletonGenderDetector ??= _onTripModule.genderDetector(
          _createTripDetector(), _createFaceDetector());
  _i28.TripDetector _createTripDetector() =>
      _singletonTripDetector ??= _onTripModule.tripDetector(
          _createPowerProvider(),
          _createMovementDetector(),
          _createFaceDetector());
  _i25.MovementDetector _createMovementDetector() =>
      _singletonMovementDetector ??=
          _gpsModule.movementDetector(_createGpsController());
  _i27.FaceDetector _createFaceDetector() => _singletonFaceDetector ??=
      _onTripModule.faceDetector(_createCameraController());
  _i26.CameraController _createCameraController() =>
      _singletonCameraController ??= _onTripModule.cameraController(
          _createServiceManager(), _createConfig());
  _i30.AgeDetector _createAgeDetector() => _singletonAgeDetector ??=
      _onTripModule.ageDetector(_createTripDetector(), _createFaceDetector());
  _i33.KeywordDetector _createKeywordDetector() => _singletonKeywordDetector ??=
      _onTripModule.keywordDetector(_createSpeechToText());
  _i32.SpeechToText _createSpeechToText() => _singletonSpeechToText ??=
      _onTripModule.speechToText(_createMicController());
  _i31.MicController _createMicController() =>
      _singletonMicController ??= _onTripModule.micController();
  _i34.AreaDetector _createAreaDetector() => _singletonAreaDetector ??=
      _onTripModule.areaDetector(_createGpsController());
  _i11.PrefStoreReading _createPrefStoreReading() =>
      _singletonPrefStoreReading ??= _storageModule.prefStoreReading(null);
  @override
  _i3.Config get config => _createConfig();
  @override
  _i37.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i36.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i23.AdRepository get adRepository => _createAdRepository();
  @override
  _i19.CreativeDownloader get creativeDownloader => _createCreativeDownloader();
  @override
  _i17.FileUrlResolver get fileUrlResolver => _createFileUrlResolver();
  @override
  _i18.FilePathResolver get filePathResolver => _createFilePathResolver();
  @override
  _i11.PrefStoreReading get prefStoreReading => _createPrefStoreReading();
  @override
  _i11.PrefStoreWriting get prefStoreWriting => _createPrefStoreWriting();
  @override
  _i7.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i6.PowerDebugger get powerDebugger => _createPowerDebugger();
  @override
  _i13.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i12.PermissionDebugger get permissionDebugger => _createPermissionDebugger();
  @override
  _i14.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i22.GpsController get gpsController => _createGpsController();
  @override
  _i21.GpsDebugger get gpsDebugger => _createGpsDebugger();
  @override
  _i25.MovementDetector get movementDetector => _createMovementDetector();
  @override
  _i28.TripDetector get tripDetector => _createTripDetector();
  @override
  _i26.CameraController get cameraController => _createCameraController();
  @override
  _i31.MicController get micController => _createMicController();
  @override
  _i32.SpeechToText get speechToText => _createSpeechToText();
  @override
  _i33.KeywordDetector get keywordDetector => _createKeywordDetector();
  @override
  _i27.FaceDetector get faceDetector => _createFaceDetector();
  @override
  _i30.AgeDetector get ageDetector => _createAgeDetector();
  @override
  _i29.GenderDetector get genderDetector => _createGenderDetector();
  @override
  _i34.AreaDetector get areaDetector => _createAreaDetector();
}
