import 'package:flutter/services.dart';
import 'package:video_call_platform_interface/video_call_platform_interface.dart';

class TwilioVideoCallApi extends VideoCallApi {
  static const _channel = const MethodChannel('com.example/twilio_video_call');

  @override
  Future<void> call(String identity) async {
    return await _channel.invokeMethod('call', identity);
  }

  @override
  Future<void> endCall() async {
    return await _channel.invokeMethod('endCall');
  }

  @override
  Future<void> muteMe() async {
    return await _channel.invokeMethod('muteMe');
  }

  @override
  Future<void> turnOffCamera() async {
    return await _channel.invokeMethod('turnOffCamera');
  }

  @override
  Future<void> turnOnCamera() async {
    return await _channel.invokeMethod('turnOnCamera');
  }

  @override
  Future<void> unmuteMe() async {
    return await _channel.invokeMethod('unmuteMe');
  }

  @override
  Future<void> useBackCamera() async {
    return await _channel.invokeMethod('useBackCamera');
  }

  @override
  Future<void> useFrontCamera() async {
    return await _channel.invokeMethod('useFrontCamera');
  }

  static const _participantDidConnectChannel =
      EventChannel('com.example/participantDidConnect');

  @override
  Stream<bool> get participantDidConnectStream {
    return _participantDidConnectChannel.receiveBroadcastStream();
  }

  static const _participantDidDisconnectChannel =
      EventChannel('com.example/participantDidDisconnect');

  @override
  Stream<bool> get participantDidDisconnectStream {
    return _participantDidDisconnectChannel.receiveBroadcastStream();
  }

  static const _roomDidConnectChannel =
      EventChannel('com.example/roomDidConnect');

  @override
  Stream<bool> get roomDidConnectStream {
    return _roomDidConnectChannel.receiveBroadcastStream();
  }

  static const _roomDidDisconnectChannel =
      EventChannel('com.example/roomDidDisconnect');

  @override
  Stream<bool> get roomDidDisconnectStream {
    return _roomDidDisconnectChannel.receiveBroadcastStream();
  }

  static const _roomDidFailToConnectChannel =
      EventChannel('com.example/roomDidFailToConnect');

  @override
  Stream<bool> get roomDidFailToConnectStream {
    return _roomDidFailToConnectChannel.receiveBroadcastStream();
  }

  static const _didSubscribeToVideoTrackChannel =
      EventChannel('com.example/didSubscribeToVideoTrack');

  @override
  Stream<bool> get didSubscribeToVideoTrackStream {
    return _didSubscribeToVideoTrackChannel.receiveBroadcastStream();
  }

  static const _didUnsubscribeToVideoTrackChannel =
      EventChannel('com.example/didUnsubscribeToVideoTrack');

  @override
  Stream<bool> get didUnsubscribeToVideoTrackStream {
    return _didUnsubscribeToVideoTrackChannel.receiveBroadcastStream();
  }
}
