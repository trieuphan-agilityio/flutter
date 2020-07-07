import Flutter
import TwilioVideo

public protocol OnRoomDidConnectListener: NSObjectProtocol, FlutterStreamHandler {
  func onRoomDidConnect(_ room: FLTRoom)
}

public class OnRoomDidConnectListenerImpl: NSObject, OnRoomDidConnectListener {
  public static let CHANNEL_NAME: String = "com.example/room_did_connect"
  public var eventSink: FlutterEventSink?

  public func onRoomDidConnect(_ room: FLTRoom) {
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
