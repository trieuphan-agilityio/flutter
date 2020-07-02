import 'package:app/src/stores/app_settings/app_settings_store.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';
import 'package:meta/meta.dart';

class HttpTwilioAccessTokenStore implements TwilioAccessTokenStoreReading {
  HttpTwilioAccessTokenStore({
    @required this.api,
    @required this.appSettingsStore,
  });

  final String api;
  final AppSettingsStoreReading appSettingsStore;

  @override
  Future<String> fetchTwilioAccessToken({String roomName}) {
    return Future.delayed(Duration(seconds: 1), () => 'FAKE_ACCESS_TOKEN');
  }
}
