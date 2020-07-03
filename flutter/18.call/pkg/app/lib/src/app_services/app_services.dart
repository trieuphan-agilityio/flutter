import 'package:app/core.dart';
import 'package:app/src/app_services/auth_service.dart';
import 'package:app/src/app_services/settings_service.dart';
import 'package:app/src/app_services/video_call_service.dart';
import 'package:app/src/stores/app_settings/app_settings_store.dart';

export 'package:app/src/app_services/auth_service.dart';
export 'package:app/src/app_services/settings_service.dart';
export 'package:app/src/app_services/video_call_service.dart';

abstract class AppServices
    implements
        VideoCallServiceLocator,
        AuthServiceLocator,
        SettingsServiceLocator {
  static AppServices of(BuildContext context) {
    return Provider.of<AppServices>(context, listen: false);
  }

  static Future<AppServices> create(
    VideoCallService videoCallService,
    AuthService authService,
    SettingsService settingsService,
  ) async {
    await settingsService.init();
    final injector =
        AppServicesImpl._(videoCallService, authService, settingsService);
    return injector;
  }
}

class AppServicesImpl implements AppServices {
  AppServicesImpl._(
    this._videoCallService,
    this._authService,
    this._settingsService,
  );

  final VideoCallService _videoCallService;
  final AuthService _authService;
  final SettingsService _settingsService;

  VideoCallApi _singletonVideoCallApi;
  HelloApi _singletonHelloApi;
  SharedPreferences _singletonSharedPreferences;
  AppSettingsStore _singletonAppSettingsStore;

  VideoCallApi _createVideoCallApi() =>
      _singletonVideoCallApi ??= _videoCallService.videoCallApi(prefs);

  HelloApi _createHelloApi() => _singletonHelloApi ??= _authService.helloApi();

  SharedPreferences _createSharedPreferences() =>
      _singletonSharedPreferences ??= _settingsService.prefs();

  AppSettingsStore _appSettingsStore() =>
      _singletonAppSettingsStore ??= _settingsService.appSettingsStore(prefs);

  @override
  VideoCallApi get videoCallApi => _createVideoCallApi();

  @override
  HelloApi get helloApi => _createHelloApi();

  @override
  SharedPreferences get prefs => _createSharedPreferences();

  @override
  AppSettingsStore get appSettingsStore => _appSettingsStore();
}
