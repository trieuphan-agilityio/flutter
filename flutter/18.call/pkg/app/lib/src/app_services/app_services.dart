import 'package:app/src/app_services/auth_service.dart';
import 'package:app/src/app_services/video_call_service.dart';
import 'package:video_call_platform_interface/video_call_platform_interface.dart';

export 'package:app/src/app_services/auth_service.dart';
export 'package:app/src/app_services/video_call_service.dart';

abstract class AppServices
    implements VideoCallServiceLocator, AuthServiceLocator {
  static Future<AppServices> create(
    VideoCallService videoCallService,
    AuthService authService,
  ) async {
    final injector = AppServicesImpl._(videoCallService, authService);
    return injector;
  }
}

class AppServicesImpl implements AppServices {
  AppServicesImpl._(this._videoCallService, this._authService);

  final VideoCallService _videoCallService;
  final AuthService _authService;

  VideoCallApi _singletonVideoCallApi;
  HelloApi _singletonHelloApi;

  VideoCallApi _createVideoCallApi() =>
      _singletonVideoCallApi ??= _videoCallService.videoCallApi();

  HelloApi _createHelloApi() => _singletonHelloApi ??= _authService.helloApi();

  @override
  VideoCallApi get videoCallApi => _createVideoCallApi();

  @override
  HelloApi get helloApi => _createHelloApi();
}
