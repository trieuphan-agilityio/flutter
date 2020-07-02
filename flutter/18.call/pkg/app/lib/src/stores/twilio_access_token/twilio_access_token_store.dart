import 'package:meta/meta.dart';

abstract class TwilioAccessTokenStoreReading {
  Future<String> fetchTwilioAccessToken({@required String roomName});
}
