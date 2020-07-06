import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

class HttpTwilioAccessTokenStore implements TwilioAccessTokenStoreReading {
  @override
  Future<String> fetchTwilioAccessToken({String roomName}) {
    return Future.delayed(Duration(seconds: 1), () => 'FAKE_ACCESS_TOKEN');
  }
}
