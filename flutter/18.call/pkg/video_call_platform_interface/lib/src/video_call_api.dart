abstract class VideoCallApi {
  Future<void> call(String identity);
  Future<void> endCall();
  Future<void> muteMe();
  Future<void> unmuteMe();
  Future<void> useFrontCamera();
  Future<void> useBackCamera();
  Future<void> turnOffCamera();
  Future<void> turnOnCamera();

  Stream<bool> get roomDidConnectStream;
  Stream<bool> get roomDidDisconnectStream;
  Stream<bool> get roomDidFailToConnectStream;
  Stream<bool> get participantDidConnectStream;
  Stream<bool> get participantDidDisconnectStream;
  Stream<bool> get didSubscribeToVideoTrackStream;
  Stream<bool> get didUnsubscribeToVideoTrackStream;
}
