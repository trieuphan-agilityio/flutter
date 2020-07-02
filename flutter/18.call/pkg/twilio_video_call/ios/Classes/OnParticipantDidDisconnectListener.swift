import Flutter
import TwilioVideo

public protocol OnParticipantDidDisconnectListener: NSObjectProtocol, FlutterStreamHandler {
  func onParticipantDidDisconnect(room: Room)
}

public class OnParticipantDidDisconnectListenerImpl: NSObject, OnParticipantDidDisconnectListener {
  public static let CHANNEL_NAME: String = "com.example/participant_did_disconnect"
  public var eventSink: FlutterEventSink?

  public func onParticipantDidDisconnect(room: Room) {
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
