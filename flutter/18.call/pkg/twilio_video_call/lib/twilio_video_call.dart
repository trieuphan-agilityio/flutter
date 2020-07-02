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
    return await _channel.invokeMethod('end_call');
  }

  @override
  Future<void> muteMe() async {
    return await _channel.invokeMethod('mute_me');
  }

  @override
  Future<void> turnOffCamera() async {
    return await _channel.invokeMethod('turn_off_camera');
  }

  @override
  Future<void> turnOnCamera() async {
    return await _channel.invokeMethod('turn_on_camera');
  }

  @override
  Future<void> unmuteMe() async {
    return await _channel.invokeMethod('unmute_me');
  }

  @override
  Future<void> useBackCamera() async {
    return await _channel.invokeMethod('use_back_camera');
  }

  @override
  Future<void> useFrontCamera() async {
    return await _channel.invokeMethod('use_front_camera');
  }

  static const _participantDidConnectChannel =
      EventChannel('com.example/participant_did_connect');

  @override
  Stream<bool> get participantDidConnectStream {
    return _participantDidConnectChannel.receiveBroadcastStream();
  }

  static const _participantDidDisconnectChannel =
      EventChannel('com.example/participant_did_disconnect');

  @override
  Stream<bool> get participantDidDisconnectStream {
    return _participantDidDisconnectChannel.receiveBroadcastStream();
  }

  static const _roomDidConnectChannel =
      EventChannel('com.example/room_did_connect');

  @override
  Stream<bool> get roomDidConnectStream {
    return _roomDidConnectChannel.receiveBroadcastStream();
  }

  static const _roomDidDisconnectChannel =
      EventChannel('com.example/room_did_disconnect');

  @override
  Stream<bool> get roomDidDisconnectStream {
    return _roomDidDisconnectChannel.receiveBroadcastStream();
  }

  static const _roomDidFailToConnectChannel =
      EventChannel('com.example/room_did_fail_to_connect');

  @override
  Stream<bool> get roomDidFailToConnectStream {
    return _roomDidFailToConnectChannel.receiveBroadcastStream();
  }

  static const _didSubscribeToVideoTrackChannel =
      EventChannel('com.example/did_subscribe_to_video_track');

  @override
  Stream<bool> get didSubscribeToVideoTrackStream {
    return _didSubscribeToVideoTrackChannel.receiveBroadcastStream();
  }

  static const _didUnsubscribeToVideoTrackChannel =
      EventChannel('com.example/did_unsubscribe_to_video_track');

  @override
  Stream<bool> get didUnsubscribeToVideoTrackStream {
    return _didUnsubscribeToVideoTrackChannel.receiveBroadcastStream();
  }
}
