import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

// replace with an access token are derived from Twilio Console
const String _fixedAccessToken = 'FAKE_ACCESS_TOKEN';

class FixedTwilioAccessTokenStore implements TwilioAccessTokenStoreReading {
  @override
  Future<String> fetchTwilioAccessToken({String roomName}) {
    return Future.value(_fixedAccessToken);
  }
}
