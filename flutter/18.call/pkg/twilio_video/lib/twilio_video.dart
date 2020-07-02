import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:twilio_video/models.dart';

abstract class TwilioVideo {
  Future<Room> connect({@required ConnectOptions options});
  Future<void> disconnect();

  Stream<bool> get roomDidConnectStream;
  Stream<bool> get roomDidDisconnectStream;
  Stream<bool> get roomDidFailToConnectStream;
  Stream<bool> get participantDidConnectStream;
  Stream<bool> get participantDidDisconnectStream;
  Stream<bool> get didSubscribeToVideoTrackStream;
  Stream<bool> get didUnsubscribeToVideoTrackStream;
}

class ChannelTwilioVideo extends TwilioVideo {
  static const _channel = const MethodChannel('com.example/twilio_video');

  @override
  Future<Room> connect({@required ConnectOptions options}) async {
    return await _channel.invokeMethod('connect', options);
  }

  @override
  Future<void> disconnect() async {
    return await _channel.invokeMethod('disconnect');
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
