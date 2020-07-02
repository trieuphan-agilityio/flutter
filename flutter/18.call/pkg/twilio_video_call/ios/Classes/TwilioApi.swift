import Foundation
import TwilioVideo

public protocol VideoCallApi {
  func call(identity: String)
  func endCall()
  func muteMe()
  func unmuteMe()
  func turnOnCamera()
  func turnOffCamera()
  func useFrontCamera()
  func useBackCamera()

  var onRoomDidConnectListener: OnRoomDidConnectListener? { get set }
  var onRoomDidDisconnectListener: OnRoomDidDisconnectListener? { get set }
  var onRoomDidFailToConnectListener: OnRoomDidFailToConnectListener? { get set }
  var onParticipantDidConnectListener: OnParticipantDidConnectListener? { get set }
  var onParticipantDidDisconnectListener: OnParticipantDidDisconnectListener? { get set }
  var onDidSubscribeToVideoTrackListener: OnDidSubscribeToVideoTrackListener? { get set }
  var onDidUnsubscribeToVideoTrackListener: OnDidUnsubscribeToVideoTrackListener? { get set }
}

public class TwilioApi: NSObject {
  private var room: Room?
  public var onRoomDidConnectListener: OnRoomDidConnectListener?
  public var onRoomDidDisconnectListener: OnRoomDidDisconnectListener?
  public var onRoomDidFailToConnectListener: OnRoomDidFailToConnectListener?
  public var onParticipantDidConnectListener: OnParticipantDidConnectListener?
  public var onParticipantDidDisconnectListener: OnParticipantDidDisconnectListener?
  public var onDidSubscribeToVideoTrackListener: OnDidSubscribeToVideoTrackListener?
  public var onDidUnsubscribeToVideoTrackListener: OnDidUnsubscribeToVideoTrackListener?

  private override init() {}
  static let instance = TwilioApi()
}

class NilHandler: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    return nil
  }
}

// MARK: - VideoCallApi

extension TwilioApi: VideoCallApi {

  public func call(identity: String) {
    let accessToken = ""
    let options = ConnectOptions(token: accessToken)
    room = TwilioVideoSDK.connect(options: options, delegate: self)
  }

  public func endCall() {
    room?.disconnect()
  }

  public func muteMe() {
    
  }

  public func unmuteMe() {

  }

  public func useFrontCamera() {

  }

  public func useBackCamera() {

  }

  public func turnOnCamera() {

  }

  public func turnOffCamera() {

  }
}

// MARK: - RoomDelegate

extension TwilioApi: RoomDelegate {
  public func roomDidConnect(room: Room) {
    onRoomDidConnectListener?.onRoomDidConnect(room: room)
  }

  public func roomDidDisconnect(room: Room, error: Error?) {
    onRoomDidDisconnectListener?.onRoomDidDisconnect(room: room)
  }

  public func roomDidFailToConnect(room: Room, error: Error) {
    onRoomDidFailToConnectListener?.onRoomDidFailToConnect(room: room)
  }

  public func participantDidConnect(room: Room, participant: RemoteParticipant) {
    onParticipantDidConnectListener?.onParticipantDidConnect(room: room)

    // Not handled participant delegate yet
    // participant.delegate = self
  }

  public func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
    onParticipantDidDisconnectListener?.onParticipantDidDisconnect(room: room)
  }
}

// MARK: - RemoteParticipantDelegate

extension TwilioApi: RemoteParticipantDelegate {

}
