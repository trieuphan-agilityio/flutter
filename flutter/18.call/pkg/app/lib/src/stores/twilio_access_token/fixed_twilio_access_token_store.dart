import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

// replace with an access token are derived from Twilio Console
const String _fixedAccessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzgzZjVlNzgyYWEwMTg5NGJhZTI1ODg0NTFjZGU4NjgyLTE1OTM3NzI5NDEiLCJpc3MiOiJTSzgzZjVlNzgyYWEwMTg5NGJhZTI1ODg0NTFjZGU4NjgyIiwic3ViIjoiQUMxZjhkZDFkODhlOTFhOGE4MjFlNzE1M2U1ZWEyMjkwYSIsImV4cCI6MTU5Mzc3NjU0MSwiZ3JhbnRzIjp7ImlkZW50aXR5Ijoia2ltIiwidmlkZW8iOnsicm9vbSI6ImtpbTpqb2huIn19fQ.3pdg6mIhe99_iBElsVTtOYl39IHa0QgC7NUEcRuYw1M';

class FixedTwilioAccessTokenStore implements TwilioAccessTokenStoreReading {
  @override
  Future<String> fetchTwilioAccessToken({String roomName}) {
    return Future.value(_fixedAccessToken);
  }
}
