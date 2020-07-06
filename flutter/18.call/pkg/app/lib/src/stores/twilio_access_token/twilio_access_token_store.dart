import 'package:meta/meta.dart';

enum TwilioAccessTokenMode {
  debug,
  fixed,
  http,
}

abstract class TwilioAccessTokenStoreReading {
  Future<String> fetchTwilioAccessToken({@required String roomName});
}
