import 'package:app/core.dart';
import 'package:app/model.dart';
import 'package:app/src/stores/app_settings/app_settings_store.dart';
import 'package:app/src/stores/twilio_access_token/fixed_twilio_access_token_store.dart';
import 'package:app/src/stores/twilio_access_token/twilio_access_token_store.dart';

abstract class VideoCallServiceLocator {
  VideoCallApi get videoCallApi;
}

class VideoCallService {
  VideoCallApi videoCallApi(SharedPreferences prefs) {
    return new TwilioVideoCallApi(
      api: MethodChannelTwilioVideo.shared(),
      accessTokenStore: FixedTwilioAccessTokenStore(),
      appSettingsStore: AppSettingsStore(prefs),
    );
  }
}

abstract class VideoCallApi {
  Future<void> call(CallOptions callOptions);
  Future<void> endCall();
  Future<void> muteMe();
  Future<void> unmuteMe();
  Future<void> useFrontCamera();
  Future<void> useBackCamera();
  Future<void> turnOffCamera();
  Future<void> turnOnCamera();

  Stream<void> get callDidStartStream;
  Stream<void> get callDidFailToStartStream;
  Stream<void> get callDidEndStream;
}

class TwilioVideoCallApi implements VideoCallApi {
  final TwilioVideo api;
  final AppSettingsStoreReading appSettingsStore;
  final TwilioAccessTokenStoreReading accessTokenStore;

  TwilioVideoCallApi({
    @required this.api,
    @required this.appSettingsStore,
    @required this.accessTokenStore,
  });

  @override
  Future<void> call(CallOptions callOptions) async {
    final String myIdentity = appSettingsStore.myIdentity;
    assert(myIdentity != null);

    // TODO handle HTTP exception
    final String accessToken = await accessTokenStore.fetchTwilioAccessToken(
      roomName: callOptions.identity,
    );

    final ConnectOptions connectOptions = ConnectOptions()
      ..roomName =
          _makeRoomName(caller: myIdentity, recipient: callOptions.identity)
      ..accessToken = accessToken
      ..enabledVoice = true
      ..enabledVideo = callOptions.type == CallType.video;

    await api.connect(connectOptions);
  }

  @override
  Future<void> endCall() async {
    await api.disconnect();
  }

  @override
  Future<void> muteMe() {}

  @override
  Future<void> turnOffCamera() {}

  @override
  Future<void> turnOnCamera() {}

  @override
  Future<void> unmuteMe() {}

  @override
  Future<void> useBackCamera() {}

  @override
  Future<void> useFrontCamera() {}

  @override
  Stream<void> get callDidStartStream {
    // call start when recipient joins the room
    return api.roomDidConnectStream;
  }

  @override
  Stream<void> get callDidFailToStartStream {
    // call fails when the room is unable to connect
    return api.roomDidFailToConnectStream;
  }

  @override
  Stream<void> get callDidEndStream {
    // call end when recipient leaves the room
    return api.participantDidDisconnectStream;
  }

  /// Generate an unique room name based on caller & recipient identities.
  String _makeRoomName({String caller, String recipient}) {
    final sortedIdentities = [caller, recipient]..sort();
    return sortedIdentities.join(':');
  }
}
