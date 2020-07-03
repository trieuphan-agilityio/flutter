import Flutter
import TwilioVideo

public protocol OnRoomDidFailToConnectListener: NSObjectProtocol, FlutterStreamHandler {
  func onRoomDidFailToConnect()
}

public class OnRoomDidFailToConnectListenerImpl: NSObject, OnRoomDidFailToConnectListener {
  public static let CHANNEL_NAME: String = "com.example/room_did_fail_to_connect"
  public var eventSink: FlutterEventSink?

  public func onRoomDidFailToConnect() {
    eventSink?(nil)
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
