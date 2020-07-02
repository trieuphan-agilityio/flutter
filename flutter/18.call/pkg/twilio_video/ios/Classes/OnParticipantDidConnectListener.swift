import Flutter
import TwilioVideo

public protocol OnParticipantDidConnectListener: NSObjectProtocol, FlutterStreamHandler {
  func onParticipantDidConnect(room: Room)
}

public class OnParticipantDidConnectListenerImpl: NSObject, OnParticipantDidConnectListener {
  public static let CHANNEL_NAME: String = "com.example/participant_did_connect"
  public var eventSink: FlutterEventSink?

  public func onParticipantDidConnect(room: Room) {
    eventSink?(room)
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
