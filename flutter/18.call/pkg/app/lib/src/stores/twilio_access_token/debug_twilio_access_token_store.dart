import 'package:app/core.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';
import 'package:meta/meta.dart';

const String _kAccessToken = 'DebugTwilioAccessTokenStore/key';

class DebugTwilioAccessTokenStore implements TwilioAccessTokenStoreReading {
  final SharedPreferences prefs;

  DebugTwilioAccessTokenStore({@required this.prefs});

  @override
  Future<String> fetchTwilioAccessToken({String roomName}) async {
    return prefs.getString(_kAccessToken) ?? '';
  }

  set twilioAccessToken(String newValue) {
    prefs.setString(_kAccessToken, newValue);
  }
}
