import 'package:app/src/models/participants/local_participant.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

class Room {
  final LocalParticipant localParticipant;
  final TwilioAccessTokenStoreReading accessTokenStore;

  Room({
    this.localParticipant,
    this.accessTokenStore,
  });

  connect(roomName: String) {

  }
}
