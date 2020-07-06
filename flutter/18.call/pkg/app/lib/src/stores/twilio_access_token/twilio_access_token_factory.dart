import 'package:app/core.dart';
import 'package:app/src/stores/app_settings/app_settings_store.dart';
import 'package:app/src/stores/twilio_access_token/debug_twilio_access_token_store.dart';
import 'package:app/src/stores/twilio_access_token/fixed_twilio_access_token_store.dart';
import 'package:app/src/stores/twilio_access_token/http_twilio_access_token_store.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

class TwilioAccessTokenFactory {
  final AppSettingsStoreReading appSettingsStore;
  final SharedPreferences prefs;

  TwilioAccessTokenFactory({
    @required this.appSettingsStore,
    @required this.prefs,
  });

  TwilioAccessTokenStoreReading makeTwilioAccessTokenStore() {
    switch (appSettingsStore.twilioAccessTokenMode) {
      case TwilioAccessTokenMode.fixed:
        return FixedTwilioAccessTokenStore();

      case TwilioAccessTokenMode.http:
        return HttpTwilioAccessTokenStore();

      case TwilioAccessTokenMode.debug:
        return DebugTwilioAccessTokenStore(prefs: prefs);

      default:
        return FixedTwilioAccessTokenStore();
    }
  }
}
