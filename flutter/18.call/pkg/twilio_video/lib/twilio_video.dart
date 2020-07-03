library twilio_video;

import 'package:flutter/services.dart';
import 'package:twilio_video/models.dart';

abstract class TwilioVideo {
  Future<Room> connect(ConnectOptions options);
  Future<void> disconnect();

  Stream<void> get roomDidConnectStream;
  Stream<void> get roomDidDisconnectStream;
  Stream<void> get roomDidFailToConnectStream;
  Stream<void> get participantDidConnectStream;
  Stream<void> get participantDidDisconnectStream;
  Stream<void> get didSubscribeToVideoTrackStream;
  Stream<void> get didUnsubscribeToVideoTrackStream;
}

class MethodChannelTwilioVideo extends TwilioVideo {
  factory MethodChannelTwilioVideo.shared() {
    if (_instance == null) {
      _instance = MethodChannelTwilioVideo._();
    }
    return _instance;
  }
  MethodChannelTwilioVideo._();

  static MethodChannelTwilioVideo _instance;

  static const _channel = const MethodChannel('com.example/twilio_video');

  @override
  Future<Room> connect(ConnectOptions options) async {
    final Map<String, dynamic> argMap = options.toJson();
    final Map<String, dynamic> retMap =
        await _channel.invokeMethod<Map<String, dynamic>>('connect', argMap);

    if (retMap == null) {
      throw PlatformException(
          code: 'channel-error',
          message: 'Unable to establish connection on channel.',
          details: null);
    } else if (retMap['error'] != null) {
      final Map<dynamic, dynamic> error = retMap['error'];
      throw PlatformException(
          code: error['code'],
          message: error['message'],
          details: error['details']);
    } else {
      return Room.fromJson(retMap['result']);
    }
  }

  @override
  Future<void> disconnect() async {
    return await _channel.invokeMethod('disconnect');
  }

  static const _participantDidConnectChannel =
      EventChannel('com.example/participant_did_connect');

  @override
  Stream<void> get participantDidConnectStream {
    return _participantDidConnectChannel.receiveBroadcastStream();
  }

  static const _participantDidDisconnectChannel =
      EventChannel('com.example/participant_did_disconnect');

  @override
  Stream<void> get participantDidDisconnectStream {
    return _participantDidDisconnectChannel.receiveBroadcastStream();
  }

  static const _roomDidConnectChannel =
      EventChannel('com.example/room_did_connect');

  @override
  Stream<void> get roomDidConnectStream {
    return _roomDidConnectChannel.receiveBroadcastStream().map((e) => true);
  }

  static const _roomDidDisconnectChannel =
      EventChannel('com.example/room_did_disconnect');

  @override
  Stream<void> get roomDidDisconnectStream {
    return _roomDidDisconnectChannel.receiveBroadcastStream().map((e) => true);
  }

  static const _roomDidFailToConnectChannel =
      EventChannel('com.example/room_did_fail_to_connect');

  @override
  Stream<void> get roomDidFailToConnectStream {
    return _roomDidFailToConnectChannel
        .receiveBroadcastStream()
        .map((e) => true);
  }

  static const _didSubscribeToVideoTrackChannel =
      EventChannel('com.example/did_subscribe_to_video_track');

  @override
  Stream<void> get didSubscribeToVideoTrackStream {
    return _didSubscribeToVideoTrackChannel.receiveBroadcastStream();
  }

  static const _didUnsubscribeToVideoTrackChannel =
      EventChannel('com.example/did_unsubscribe_to_video_track');

  @override
  Stream<void> get didUnsubscribeToVideoTrackStream {
    return _didUnsubscribeToVideoTrackChannel.receiveBroadcastStream();
  }
}
