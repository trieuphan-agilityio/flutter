import Flutter
import TwilioVideo

public protocol OnRoomDidDisconnectListener: NSObjectProtocol, FlutterStreamHandler {
  func onRoomDidDisconnect(_ room: FLTRoom)
}

public class OnRoomDidDisconnectListenerImpl: NSObject, OnRoomDidDisconnectListener {
  public static let CHANNEL_NAME: String = "com.example/room_did_disconnect"
  public var eventSink: FlutterEventSink?

  public func onRoomDidDisconnect(_ room: FLTRoom) {
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
