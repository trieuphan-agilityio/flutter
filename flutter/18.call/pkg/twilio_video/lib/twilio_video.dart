library twilio_video;

import 'package:flutter/services.dart';
import 'package:twilio_video/models.dart';

abstract class TwilioVideo {
  Future<Room> connect(ConnectOptions options);
  Future<void> disconnect();

  Stream<Room> get roomDidConnectStream;
  Stream<Room> get roomDidDisconnectStream;
  Stream<Room> get roomDidFailToConnectStream;
  Stream<Room> get participantDidConnectStream;
  Stream<Room> get participantDidDisconnectStream;

  /// For now these streams are not in use.
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
        await _channel.invokeMapMethod<String, dynamic>('connect', argMap);

    return Room.fromJson(retMap);
  }

  @override
  Future<void> disconnect() async {
    return await _channel.invokeMethod('disconnect');
  }

  static const _participantDidConnectChannel =
      EventChannel('com.example/participant_did_connect');

  @override
  Stream<Room> get participantDidConnectStream {
    return _participantDidConnectChannel
        .receiveBroadcastStream()
        .map(_parseRoomFromJson);
  }

  static const _participantDidDisconnectChannel =
      EventChannel('com.example/participant_did_disconnect');

  @override
  Stream<Room> get participantDidDisconnectStream {
    return _participantDidDisconnectChannel
        .receiveBroadcastStream()
        .map(_parseRoomFromJson);
  }

  static const _roomDidConnectChannel =
      EventChannel('com.example/room_did_connect');

  @override
  Stream<Room> get roomDidConnectStream {
    return _roomDidConnectChannel
        .receiveBroadcastStream()
        .map(_parseRoomFromJson);
  }

  static const _roomDidDisconnectChannel =
      EventChannel('com.example/room_did_disconnect');

  @override
  Stream<Room> get roomDidDisconnectStream {
    return _roomDidDisconnectChannel
        .receiveBroadcastStream()
        .map(_parseRoomFromJson);
  }

  static const _roomDidFailToConnectChannel =
      EventChannel('com.example/room_did_fail_to_connect');

  @override
  Stream<Room> get roomDidFailToConnectStream {
    return _roomDidFailToConnectChannel
        .receiveBroadcastStream()
        .map(_parseRoomFromJson);
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

  static Room _parseRoomFromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json);
    final room = Room.fromJson(map);
    return room;
  }
}
