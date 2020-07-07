library twilio_video;

class ConnectOptions {
  String accessToken;
  String roomName;
  bool enabledVoice;
  bool enabledVideo;

  // ignore: unused_element
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['accessToken'] = accessToken;
    map['roomName'] = roomName;
    map['enabledVoice'] = enabledVoice;
    map['enabledVideo'] = enabledVideo;
    return map;
  }
}

/// Simple form of a Twilio Room, it's used to determine the status of the call.
class Room {
  String sid;
  String name;
  int numOfRemoteParticipants;

  /// Simple criteria to determine whether recipients has joined or leaved.
  bool get isRecipientJoined => numOfRemoteParticipants > 1;
  bool get isRecipientLeaved => numOfRemoteParticipants == 0;

  @override
  String toString() {
    return 'Room{sid: $sid, name: $name, numOfRemoteParticipants: $numOfRemoteParticipants}';
  } // ignore: unused_element

  static Room fromJson(Map<String, dynamic> map) {
    final Room result = Room()
      ..sid = map['sid']
      ..name = map['name']
      ..numOfRemoteParticipants = map['numOfRemoteParticipants'];
    return result;
  }
}
