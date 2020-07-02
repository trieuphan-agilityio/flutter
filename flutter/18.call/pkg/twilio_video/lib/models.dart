enum TrackName { camera, mic }

class LocalVideoTrack {
  final TrackName name;
  final bool enabled;

  LocalVideoTrack({this.name = TrackName.camera, this.enabled});
}

class LocalAudioTrack {
  final TrackName name;
  final bool enabled;

  LocalAudioTrack({this.name = TrackName.mic, this.enabled});
}

class LocalParticipant {
  final LocalAudioTrack audioTrack;
  final LocalVideoTrack videoTrack;

  LocalParticipant(this.audioTrack, this.videoTrack);
}

class ConnectOptions {
  final String accessToken;
  final String roomName;
  final List<LocalAudioTrack> audioTracks;
  final List<LocalVideoTrack> videoTracks;

  ConnectOptions({
    this.accessToken,
    this.roomName,
    this.audioTracks,
    this.videoTracks,
  });
}

class Room {
  List<LocalParticipant> localParticipants;
}
