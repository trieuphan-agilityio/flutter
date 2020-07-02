import 'package:app/core.dart';
import 'package:app/src/app_services/auth_service.dart';
import 'package:app/src/app_services/shared_preferences_service.dart';
import 'package:app/src/app_services/video_call_service.dart';

export 'package:app/src/app_services/auth_service.dart';
export 'package:app/src/app_services/shared_preferences_service.dart';
export 'package:app/src/app_services/video_call_service.dart';

abstract class AppServices
    implements
        VideoCallServiceLocator,
        AuthServiceLocator,
        SharedPreferencesServiceLocator {
  static AppServices of(BuildContext context) {
    return Provider.of<AppServices>(context, listen: false);
  }

  static Future<AppServices> create(
    VideoCallService videoCallService,
    AuthService authService,
    SharedPreferencesService sharedPreferencesService,
  ) async {
    await sharedPreferencesService.init();
    final injector = AppServicesImpl._(
        videoCallService, authService, sharedPreferencesService);
    return injector;
  }
}

class AppServicesImpl implements AppServices {
  AppServicesImpl._(
    this._videoCallService,
    this._authService,
    this._sharedPreferencesService,
  );

  final VideoCallService _videoCallService;
  final AuthService _authService;
  final SharedPreferencesService _sharedPreferencesService;

  VideoCallApi _singletonVideoCallApi;
  HelloApi _singletonHelloApi;
  SharedPreferences _singletonSharedPreferences;

  VideoCallApi _createVideoCallApi() =>
      _singletonVideoCallApi ??= _videoCallService.videoCallApi();

  HelloApi _createHelloApi() => _singletonHelloApi ??= _authService.helloApi();

  SharedPreferences _createSharedPreferences() =>
      _singletonSharedPreferences ??= _sharedPreferencesService.prefs();

  @override
  VideoCallApi get videoCallApi => _createVideoCallApi();

  @override
  HelloApi get helloApi => _createHelloApi();

  @override
  SharedPreferences get prefs => _createSharedPreferences();
}
