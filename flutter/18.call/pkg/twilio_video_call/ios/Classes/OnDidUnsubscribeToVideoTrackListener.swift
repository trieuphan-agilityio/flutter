import Flutter
import TwilioVideo

public protocol OnDidUnsubscribeToVideoTrackListener: NSObjectProtocol, FlutterStreamHandler {
  func onDidUnsubscribeToVideoTrack(room: Room)
}

public class OnDidUnsubscribeToVideoTrackListenerImpl: NSObject, OnDidUnsubscribeToVideoTrackListener {
  public static let CHANNEL_NAME: String = "com.example/did_unsubscribe_to_video_track"
  public var eventSink: FlutterEventSink?

  public func onDidUnsubscribeToVideoTrack(room: Room) {
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
