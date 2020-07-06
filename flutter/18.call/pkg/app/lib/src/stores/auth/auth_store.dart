import 'package:app/core.dart';

abstract class AuthStoreReading {
  String get accessToken;
}

const String _kAccessTokenKey = 'ACCESS_TOKEN';

/// Application's Access Token that used to identify user, it's not Twilio Access
/// Token which is related to a specific Twilio users & room.
class AuthStore implements AuthStoreReading {
  AuthStore({this.prefs});

  final SharedPreferences prefs;

  @override
  String get accessToken {
    return prefs.get(_kAccessTokenKey) ?? '';
  }

  set accessToken(String newValue) {
    prefs.setString(_kAccessTokenKey, newValue);
  }
}
