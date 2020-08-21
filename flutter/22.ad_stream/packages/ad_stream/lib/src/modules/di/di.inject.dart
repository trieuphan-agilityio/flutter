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
import '../ad/ad_api_client.dart' as _i12;
import '../common/common_module.dart' as _i13;
import '../common/file_url_resolver.dart' as _i14;
import '../common/file_path_resolver.dart' as _i15;
import '../ad/creative_downloader.dart' as _i16;
import '../gps/gps_module.dart' as _i17;
import '../gps/debugger/gps_debugger.dart' as _i18;
import '../gps/gps_controller.dart' as _i19;
import '../ad/ad_repository.dart' as _i20;
import '../on_trip/on_trip_module.dart' as _i21;
import '../on_trip/camera_controller.dart' as _i22;
import '../on_trip/face_detector.dart' as _i23;
import '../on_trip/gender_detector.dart' as _i24;
import '../on_trip/age_detector.dart' as _i25;
import '../on_trip/mic_controller.dart' as _i26;
import '../on_trip/speech_to_text.dart' as _i27;
import '../on_trip/keyword_detector.dart' as _i28;
import '../on_trip/area_detector.dart' as _i29;
import '../ad/ad_scheduler.dart' as _i30;
import '../ad/ad_presenter.dart' as _i31;
import '../gps/movement_detector.dart' as _i32;
import '../on_trip/trip_detector.dart' as _i33;
import 'dart:async' as _i34;

class DI$Injector implements _i1.DI {
  DI$Injector._(
      this._adModule,
      this._serviceManagerModule,
      this._powerModule,
      this._permissionModule,
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

  _i9.PermissionDebugger _singletonPermissionDebugger;

  _i10.PermissionController _singletonPermissionController;

  _i11.ServiceManager _singletonServiceManager;

  _i12.AdApiClient _singletonAdApiClient;

  final _i13.CommonModule _commonModule;

  _i14.FileUrlResolver _singletonFileUrlResolver;

  _i15.FilePathResolver _singletonFilePathResolver;

  _i16.CreativeDownloader _singletonCreativeDownloader;

  final _i17.GpsModule _gpsModule;

  _i18.GpsDebugger _singletonGpsDebugger;

  _i19.GpsController _singletonGpsController;

  _i20.AdRepository _singletonAdRepository;

  final _i21.OnTripModule _onTripModule;

  _i22.CameraController _singletonCameraController;

  _i23.FaceDetector _singletonFaceDetector;

  _i24.GenderDetector _singletonGenderDetector;

  _i25.AgeDetector _singletonAgeDetector;

  _i26.MicController _singletonMicController;

  _i27.SpeechToText _singletonSpeechToText;

  _i28.KeywordDetector _singletonKeywordDetector;

  _i29.AreaDetector _singletonAreaDetector;

  _i30.AdScheduler _singletonAdScheduler;

  _i31.AdPresenter _singletonAdPresenter;

  _i32.MovementDetector _singletonMovementDetector;

  _i33.TripDetector _singletonTripDetector;

  static _i34.Future<_i1.DI> create(
      _i2.AdModule adModule,
      _i13.CommonModule commonModule,
      _i5.PowerModule powerModule,
      _i8.PermissionModule permissionModule,
      _i4.ServiceManagerModule serviceManagerModule,
      _i17.GpsModule gpsModule,
      _i21.OnTripModule onTripModule) async {
    final injector = DI$Injector._(adModule, serviceManagerModule, powerModule,
        permissionModule, commonModule, gpsModule, onTripModule);

    return injector;
  }

  _i3.Config _createConfig() =>
      _singletonConfig ??= _adModule.config(_createConfigFactory());
  _i3.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adModule.configFactory();
  _i31.AdPresenter _createAdPresenter() =>
      _singletonAdPresenter ??= _adModule.adPresenter(
          _createServiceManager(), _createAdScheduler(), _createConfig());
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
  _i30.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adModule.adScheduler(
          _createServiceManager(),
          _createAdRepository(),
          _createConfig(),
          _createGenderDetector(),
          _createAgeDetector(),
          _createKeywordDetector(),
          _createAreaDetector());
  _i20.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adModule.adRepository(
          _createAdApiClient(),
          _createCreativeDownloader(),
          _createConfig(),
          _createServiceManager(),
          _createGpsController());
  _i12.AdApiClient _createAdApiClient() =>
      _singletonAdApiClient ??= _adModule.adApiClient();
  _i16.CreativeDownloader _createCreativeDownloader() =>
      _singletonCreativeDownloader ??= _adModule.creativeDownloader(
          _createFileUrlResolver(), _createFilePathResolver(), _createConfig());
  _i14.FileUrlResolver _createFileUrlResolver() => _singletonFileUrlResolver ??=
      _commonModule.fileUrlResolver(_createConfig());
  _i15.FilePathResolver _createFilePathResolver() =>
      _singletonFilePathResolver ??=
          _commonModule.filePathResolver(_createConfig());
  _i19.GpsController _createGpsController() => _singletonGpsController ??=
      _gpsModule.gpsController(_createServiceManager(), _createGpsDebugger());
  _i18.GpsDebugger _createGpsDebugger() =>
      _singletonGpsDebugger ??= _gpsModule.gpsDebugger();
  _i24.GenderDetector _createGenderDetector() => _singletonGenderDetector ??=
      _onTripModule.genderDetector(_createFaceDetector());
  _i23.FaceDetector _createFaceDetector() => _singletonFaceDetector ??=
      _onTripModule.faceDetector(_createCameraController());
  _i22.CameraController _createCameraController() =>
      _singletonCameraController ??= _onTripModule.cameraController();
  _i25.AgeDetector _createAgeDetector() => _singletonAgeDetector ??=
      _onTripModule.ageDetector(_createFaceDetector());
  _i28.KeywordDetector _createKeywordDetector() => _singletonKeywordDetector ??=
      _onTripModule.keywordDetector(_createSpeechToText());
  _i27.SpeechToText _createSpeechToText() => _singletonSpeechToText ??=
      _onTripModule.speechToText(_createMicController());
  _i26.MicController _createMicController() =>
      _singletonMicController ??= _onTripModule.micController();
  _i29.AreaDetector _createAreaDetector() => _singletonAreaDetector ??=
      _onTripModule.areaDetector(_createGpsController());
  _i32.MovementDetector _createMovementDetector() =>
      _singletonMovementDetector ??=
          _gpsModule.movementDetector(_createGpsController());
  _i33.TripDetector _createTripDetector() =>
      _singletonTripDetector ??= _onTripModule.tripDetector(
          _createPowerProvider(),
          _createMovementDetector(),
          _createFaceDetector());
  @override
  _i3.Config get config => _createConfig();
  @override
  _i31.AdPresenter get adPresenter => _createAdPresenter();
  @override
  _i30.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i20.AdRepository get adRepository => _createAdRepository();
  @override
  _i16.CreativeDownloader get creativeDownloader => _createCreativeDownloader();
  @override
  _i14.FileUrlResolver get fileUrlResolver => _createFileUrlResolver();
  @override
  _i15.FilePathResolver get filePathResolver => _createFilePathResolver();
  @override
  _i7.PowerProvider get powerProvider => _createPowerProvider();
  @override
  _i6.PowerDebugger get powerDebugger => _createPowerDebugger();
  @override
  _i10.PermissionController get permissionController =>
      _createPermissionController();
  @override
  _i9.PermissionDebugger get permissionDebugger => _createPermissionDebugger();
  @override
  _i11.ServiceManager get serviceManager => _createServiceManager();
  @override
  _i19.GpsController get gpsController => _createGpsController();
  @override
  _i18.GpsDebugger get gpsDebugger => _createGpsDebugger();
  @override
  _i32.MovementDetector get movementDetector => _createMovementDetector();
  @override
  _i33.TripDetector get tripDetector => _createTripDetector();
  @override
  _i22.CameraController get cameraController => _createCameraController();
  @override
  _i26.MicController get micController => _createMicController();
  @override
  _i27.SpeechToText get speechToText => _createSpeechToText();
  @override
  _i28.KeywordDetector get keywordDetector => _createKeywordDetector();
  @override
  _i23.FaceDetector get faceDetector => _createFaceDetector();
  @override
  _i25.AgeDetector get ageDetector => _createAgeDetector();
  @override
  _i24.GenderDetector get genderDetector => _createGenderDetector();
  @override
  _i29.AreaDetector get areaDetector => _createAreaDetector();
}
