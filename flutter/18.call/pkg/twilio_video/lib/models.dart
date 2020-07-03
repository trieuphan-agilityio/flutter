library twilio_video;

class LocalVideoTrack {
  String name = 'camera';
  bool enabled;

  // ignore: unused_element
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['name'] = name.toString();
    map['enabled'] = enabled;
    return map;
  }

  // ignore: unused_element
  static LocalVideoTrack fromJson(Map<String, dynamic> map) {
    final LocalVideoTrack result = LocalVideoTrack()
      ..name = map['name']
      ..enabled = map['enabled'];
    return result;
  }
}

class LocalAudioTrack {
  String name = 'mic';
  bool enabled;

  // ignore: unused_element
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['name'] = name.toString();
    map['enabled'] = enabled;
    return map;
  }

  // ignore: unused_element
  static LocalAudioTrack fromJson(Map<String, dynamic> map) {
    final LocalAudioTrack result = LocalAudioTrack()
      ..name = map['name']
      ..enabled = map['enabled'];
    return result;
  }
}

class LocalParticipant {
  List<LocalAudioTrack> audioTracks;
  List<LocalVideoTrack> videoTracks;

  // ignore: unused_element
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['audioTracks'] = audioTracks.map((e) => e.toJson()).toList();
    map['videoTracks'] = videoTracks.map((e) => e.toJson()).toList();
    return map;
  }

  // ignore: unused_element
  static LocalParticipant fromJson(Map<String, dynamic> map) {
    final LocalParticipant result = LocalParticipant()
      ..audioTracks = (map['audioTracks'] as List<Map<String, dynamic>>)
          .map((e) => LocalAudioTrack.fromJson(e))
          .toList()
      ..videoTracks = (map['videoTracks'] as List<Map<String, dynamic>>)
          .map((e) => LocalVideoTrack.fromJson(e))
          .toList();
    return result;
  }
}

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

class Room {
  List<LocalParticipant> localParticipants;

  // ignore: unused_element
  static Room fromJson(Map<String, dynamic> map) {
    final Room result = Room()
      ..localParticipants =
          (map['localParticipants'] as List<Map<String, dynamic>>)
              .map((e) => LocalParticipant.fromJson(e))
              .toList();
    return result;
  }
}
