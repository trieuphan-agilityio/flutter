import 'package:app/core.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

abstract class AppSettingsStoreReading {
  String get myIdentity;
  TwilioAccessTokenMode get twilioAccessTokenMode;
}

abstract class AppSettingsStoreWriting extends AppSettingsStoreReading {
  set myIdentity(String newValue);
  set twilioAccessTokenMode(TwilioAccessTokenMode newValue);
}

const String _kMyIdentity = 'AppSettingsStore/myIdentity';
const String _kTwilioAccessTokenMode = 'AppSettingsStore/twilioAccessTokenMode';

class AppSettingsStore implements AppSettingsStoreWriting {
  final SharedPreferences prefs;

  AppSettingsStore(this.prefs);

  @override
  String get myIdentity => prefs.getString(_kMyIdentity) ?? "";

  @override
  set myIdentity(String newValue) => prefs.setString(_kMyIdentity, newValue);

  @override
  TwilioAccessTokenMode get twilioAccessTokenMode {
    final mode = prefs.getString(_kTwilioAccessTokenMode);
    switch (mode) {
      case 'fixed':
        return TwilioAccessTokenMode.fixed;
      case 'http':
        return TwilioAccessTokenMode.http;
      case 'debug':
        return TwilioAccessTokenMode.debug;
      default:
        return TwilioAccessTokenMode.fixed;
    }
  }

  @override
  set twilioAccessTokenMode(TwilioAccessTokenMode newValue) {
    // set null to remove the value
    if (newValue == null) {
      prefs.remove(_kTwilioAccessTokenMode);
    }

    switch (newValue) {
      case TwilioAccessTokenMode.fixed:
        prefs.setString(_kTwilioAccessTokenMode, 'fixed');
        break;
      case TwilioAccessTokenMode.http:
        prefs.setString(_kTwilioAccessTokenMode, 'http');
        break;
      case TwilioAccessTokenMode.debug:
        prefs.setString(_kTwilioAccessTokenMode, 'debug');
        break;
      default:
        break;
    }
  }
}
