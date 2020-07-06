import 'package:app/core.dart';
import 'package:app/src/app_services/auth_service.dart';
import 'package:app/src/app_services/settings_service.dart';
import 'package:app/src/app_services/user_service.dart';
import 'package:app/src/app_services/video_call_service.dart';
import 'package:app/src/stores/app_settings/app_settings_store.dart';
import 'package:app/src/stores/user/user_store.dart';

abstract class AppServices
    implements
        VideoCallServiceLocator,
        AuthServiceLocator,
        SettingsServiceLocator,
        UserServiceLocator {
  static AppServices of(BuildContext context) {
    return Provider.of<AppServices>(context, listen: false);
  }

  static Future<AppServices> create(
    VideoCallService videoCallService,
    AuthService authService,
    SettingsService settingsService,
    UserService userService,
  ) async {
    await settingsService.init();
    final injector = AppServicesImpl._(
      videoCallService,
      authService,
      settingsService,
      userService,
    );
    return injector;
  }
}

class AppServicesImpl implements AppServices {
  AppServicesImpl._(
    this._videoCallService,
    this._authService,
    this._settingsService,
    this._userService,
  );

  final VideoCallService _videoCallService;
  final AuthService _authService;
  final SettingsService _settingsService;
  final UserService _userService;

  VideoCallApi _singletonVideoCallApi;
  HelloApi _singletonHelloApi;
  SharedPreferences _singletonSharedPreferences;
  AppSettingsStore _singletonAppSettingsStore;
  UserStoreReading _singletonUserStore;

  VideoCallApi _createVideoCallApi() =>
      _singletonVideoCallApi ??= _videoCallService.videoCallApi(
        prefs: prefs,
        appSettingsStore: appSettingsStore,
      );

  HelloApi _createHelloApi() => _singletonHelloApi ??= _authService.helloApi();

  SharedPreferences _createSharedPreferences() =>
      _singletonSharedPreferences ??= _settingsService.prefs();

  AppSettingsStore _createAppSettingsStore() =>
      _singletonAppSettingsStore ??= _settingsService.appSettingsStore(prefs);

  UserStoreReading _createUserStore() =>
      _singletonUserStore ??= _userService.userStore();

  @override
  VideoCallApi get videoCallApi => _createVideoCallApi();

  @override
  HelloApi get helloApi => _createHelloApi();

  @override
  SharedPreferences get prefs => _createSharedPreferences();

  @override
  AppSettingsStore get appSettingsStore => _createAppSettingsStore();

  @override
  UserStoreReading get userStore => _createUserStore();
}
