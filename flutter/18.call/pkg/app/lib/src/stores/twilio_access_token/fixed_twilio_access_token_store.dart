import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

// replace with an access token are derived from Twilio Console
const String _fixedAccessToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzgzZjVlNzgyYWEwMTg5NGJhZTI1ODg0NTFjZGU4NjgyLTE1OTQxMDc0OTAiLCJpc3MiOiJTSzgzZjVlNzgyYWEwMTg5NGJhZTI1ODg0NTFjZGU4NjgyIiwic3ViIjoiQUMxZjhkZDFkODhlOTFhOGE4MjFlNzE1M2U1ZWEyMjkwYSIsImV4cCI6MTU5NDExMTA5MCwiZ3JhbnRzIjp7ImlkZW50aXR5Ijoia2ltIiwidmlkZW8iOnsicm9vbSI6Imp1bGllOmtpbSJ9fX0.2hrB6xQzjoNaY685CRxnPpkC6ZgBt5XlP_fkA0WHzBM';

class FixedTwilioAccessTokenStore implements TwilioAccessTokenStoreReading {
  @override
  Future<String> fetchTwilioAccessToken({String roomName}) {
    return Future.value(_fixedAccessToken);
  }
}
