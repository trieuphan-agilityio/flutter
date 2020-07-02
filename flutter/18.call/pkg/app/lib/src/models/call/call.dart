import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';
import 'package:twilio_video/models.dart';

class Call {
  final LocalParticipant localParticipant;
  final TwilioAccessTokenStoreReading accessTokenStore;

  Call({
    this.localParticipant,
    this.accessTokenStore,
  });
}
