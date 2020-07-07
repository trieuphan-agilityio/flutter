import Flutter
import UIKit

public class SwiftTwilioVideoPlugin: NSObject, FlutterPlugin {
  private var twilioVideo: TwilioVideo = TwilioVideoImpl.instance
  private let onRoomDidConnectListener: OnRoomDidConnectListener = OnRoomDidConnectListenerImpl()
  private let onRoomDidDisconnectListener: OnRoomDidDisconnectListener = OnRoomDidDisconnectListenerImpl()
  private let onRoomDidFailToConnectListener: OnRoomDidFailToConnectListener = OnRoomDidFailToConnectListenerImpl()
  private let onParticipantDidConnectListener: OnParticipantDidConnectListener = OnParticipantDidConnectListenerImpl()
  private let onParticipantDidDisconnectListener: OnParticipantDidDisconnectListener = OnParticipantDidDisconnectListenerImpl()
  private let onDidSubscribeToVideoTrackListener: OnDidSubscribeToVideoTrackListener = OnDidSubscribeToVideoTrackListenerImpl()
  private let onDidUnsubscribeToVideoTrackListener: OnDidUnsubscribeToVideoTrackListener = OnDidUnsubscribeToVideoTrackListenerImpl()

  private var methodChannel: FlutterMethodChannel?
  private var onRoomDidConnectChannel: FlutterEventChannel?
  private var onRoomDidDisconnectChannel: FlutterEventChannel?
  private var onRoomDidFailToConnectChannel: FlutterEventChannel?
  private var onParticipantDidConnectChannel: FlutterEventChannel?
  private var onParticipantDidDisconnectChannel: FlutterEventChannel?
  private var onDidSubscribeToVideoTrackChannel: FlutterEventChannel?
  private var onDidUnsubscribeToVideoTrackChannel: FlutterEventChannel?

  init(with registrar: FlutterPluginRegistrar) {
    twilioVideo.onRoomDidConnectListener = onRoomDidConnectListener
    twilioVideo.onRoomDidDisconnectListener = onRoomDidDisconnectListener
    twilioVideo.onRoomDidFailToConnectListener = onRoomDidFailToConnectListener
    twilioVideo.onParticipantDidConnectListener = onParticipantDidConnectListener
    twilioVideo.onParticipantDidDisconnectListener = onParticipantDidDisconnectListener
    twilioVideo.onDidSubscribeToVideoTrackListener = onDidSubscribeToVideoTrackListener
    twilioVideo.onDidUnsubscribeToVideoTrackListener = onDidUnsubscribeToVideoTrackListener
  }

  // MARK: - FlutterPlugin

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "connect":
      guard let argMap = call.arguments as? [String: Any?] else {
        return result(nil)
      }
      guard let accessToken = argMap["accessToken"] as? String else {
        return missingParameter("accessToken", result)
      }
      guard let roomName = argMap["roomName"] as? String else {
        return missingParameter("roomName", result)
      }
      guard let enabledVoice = argMap["enabledVoice"] as? Bool else {
        return missingParameter("enabledVoice", result)
      }
      guard let enabledVideo = argMap["enabledVideo"] as? Bool else {
        return missingParameter("enabledVideo", result)
      }
      let room = twilioVideo.connect(
        accessToken: accessToken,
        roomName: roomName,
        enabledVoice: enabledVoice,
        enabledVideo: enabledVideo
      )
      result(room.toJson())

    case "disconnect":
      twilioVideo.disconnect()

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let plugin = SwiftTwilioVideoPlugin(with: registrar)

    // 1. Set up method channel to handle invocation from Flutter
    let methodChannel = FlutterMethodChannel(
      name: "com.example/twilio_video",
      binaryMessenger: registrar.messenger()
    )
    plugin.methodChannel = methodChannel

    registrar.addMethodCallDelegate(plugin, channel: methodChannel)
    
    // 2. Set up a view factory to create native view
    let viewFactory = ParticipantViewFactory(plugin.twilioVideo)
    registrar.register(viewFactory, withId: ParticipantViewFactory.VIEW_ID)

    // 3. Set up event channels to push event from iOS to Flutter
    // Room connected
    plugin.onRoomDidConnectChannel = FlutterEventChannel(
      name: OnRoomDidConnectListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onRoomDidConnectChannel?.setStreamHandler(plugin.onRoomDidConnectListener)

    // Room disconnected
    plugin.onRoomDidDisconnectChannel = FlutterEventChannel(
      name: OnRoomDidDisconnectListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onRoomDidDisconnectChannel?.setStreamHandler(plugin.onRoomDidDisconnectListener)

    // Room FAIL to connect
    plugin.onRoomDidFailToConnectChannel = FlutterEventChannel(
      name: OnRoomDidFailToConnectListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onRoomDidFailToConnectChannel?.setStreamHandler(plugin.onRoomDidFailToConnectListener)

    // Participant connected
    plugin.onParticipantDidConnectChannel = FlutterEventChannel(
      name: OnParticipantDidConnectListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onParticipantDidConnectChannel?.setStreamHandler(plugin.onParticipantDidConnectListener)

    // Participant disconnected
    plugin.onParticipantDidDisconnectChannel = FlutterEventChannel(
      name: OnParticipantDidDisconnectListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onParticipantDidDisconnectChannel?.setStreamHandler(plugin.onParticipantDidDisconnectListener)

    // Subscribed to Video track
    plugin.onDidSubscribeToVideoTrackChannel = FlutterEventChannel(
      name: OnDidSubscribeToVideoTrackListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onDidSubscribeToVideoTrackChannel?.setStreamHandler(plugin.onDidSubscribeToVideoTrackListener)

    // Unsubscribed to Video track
    plugin.onDidUnsubscribeToVideoTrackChannel = FlutterEventChannel(
      name: OnDidUnsubscribeToVideoTrackListenerImpl.CHANNEL_NAME,
      binaryMessenger: registrar.messenger()
    )
    plugin.onDidUnsubscribeToVideoTrackChannel?.setStreamHandler(plugin.onDidUnsubscribeToVideoTrackListener)
  }

  /**
   * Called when a plugin is being removed from a `FlutterEngine`, which is
   * usually the result of the `FlutterEngine` being deallocated.  This method
   * provides the opportunity to do necessary cleanup.
   */
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    methodChannel?.setMethodCallHandler(nil)
    onRoomDidConnectChannel?.setStreamHandler(nil)
    onRoomDidDisconnectChannel?.setStreamHandler(nil)
    onRoomDidFailToConnectChannel?.setStreamHandler(nil)
    onParticipantDidConnectChannel?.setStreamHandler(nil)
    onParticipantDidDisconnectChannel?.setStreamHandler(nil)
    onDidSubscribeToVideoTrackChannel?.setStreamHandler(nil)
    onDidUnsubscribeToVideoTrackChannel?.setStreamHandler(nil)
  }

  // MARK: Utilities

  func missingParameter(_ property: String, _ result: FlutterResult) {
    return result(FlutterError(
      code: "method-error",
      message: "Missing '\(property)' parameter",
      details: nil
    ))
  }

  func wrongType(_ property: String, _ result: FlutterResult) {
    return result(FlutterError(
      code: "method-error",
      message: "'\(property) is not correct type'",
      details: nil
    ))
  }
}
