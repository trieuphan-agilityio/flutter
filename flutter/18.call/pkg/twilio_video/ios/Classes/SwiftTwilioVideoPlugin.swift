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
    case "call":
      print("handle `call` invocation")
      twilioVideo.call(identity: "sample_identity")

    case "end_call":
      print("handle `end_call` invocation")
      twilioVideo.endCall()

    case "mute_me":
      print("handle `mute_me` invocation")
      twilioVideo.muteMe()

    case "unmute_me":
      print("handle `unmute_me` invocation")
      twilioVideo.unmuteMe()

    case "turn_on_camera":
      print("handle `turn_on_camera` invocation")
      twilioVideo.turnOnCamera()

    case "turn_off_camera":
      print("handle `turn_off_camera` invocation")
      twilioVideo.turnOffCamera()

    case "use_front_camera":
      print("handle `use_front_camera` invocation")
      twilioVideo.useFrontCamera()

    case "use_back_camera":
      print("handle `use_back_camera` invocation")
      twilioVideo.useBackCamera()

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

    // 2. Set up event channels to push event from iOS to Flutter
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
}
