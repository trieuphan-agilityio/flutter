import Flutter
import TwilioVideo

public protocol OnRoomDidFailToConnectListener: NSObjectProtocol, FlutterStreamHandler {
  func onRoomDidFailToConnect(_ room: FLTRoom)
}

public class OnRoomDidFailToConnectListenerImpl: NSObject, OnRoomDidFailToConnectListener {
  public static let CHANNEL_NAME: String = "com.example/room_did_fail_to_connect"
  public var eventSink: FlutterEventSink?

  public func onRoomDidFailToConnect(_ room: FLTRoom) {
    eventSink?(room.toJson())
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
