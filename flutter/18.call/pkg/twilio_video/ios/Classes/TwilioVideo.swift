import Foundation
import TwilioVideo

public protocol TwilioVideo {
  func connect(accessToken: String, roomName: String, enabledVoice: Bool, enabledVideo: Bool)
  func disconnect()

  var onRoomDidConnectListener: OnRoomDidConnectListener? { get set }
  var onRoomDidDisconnectListener: OnRoomDidDisconnectListener? { get set }
  var onRoomDidFailToConnectListener: OnRoomDidFailToConnectListener? { get set }
  var onParticipantDidConnectListener: OnParticipantDidConnectListener? { get set }
  var onParticipantDidDisconnectListener: OnParticipantDidDisconnectListener? { get set }
  var onDidSubscribeToVideoTrackListener: OnDidSubscribeToVideoTrackListener? { get set }
  var onDidUnsubscribeToVideoTrackListener: OnDidUnsubscribeToVideoTrackListener? { get set }
}

public class TwilioVideoImpl: NSObject {
  private var room: Room?
  public var onRoomDidConnectListener: OnRoomDidConnectListener?
  public var onRoomDidDisconnectListener: OnRoomDidDisconnectListener?
  public var onRoomDidFailToConnectListener: OnRoomDidFailToConnectListener?
  public var onParticipantDidConnectListener: OnParticipantDidConnectListener?
  public var onParticipantDidDisconnectListener: OnParticipantDidDisconnectListener?
  public var onDidSubscribeToVideoTrackListener: OnDidSubscribeToVideoTrackListener?
  public var onDidUnsubscribeToVideoTrackListener: OnDidUnsubscribeToVideoTrackListener?

  private override init() {}
  static let instance = TwilioVideoImpl()
}

// MARK: - TwilioVideo

extension TwilioVideoImpl: TwilioVideo {

  public func connect(accessToken: String, roomName: String, enabledVoice: Bool, enabledVideo: Bool) {
    let options = ConnectOptions(token: accessToken) { builder in
      builder.roomName = roomName

      let audioTrack = LocalAudioTrack(options: nil, enabled: enabledVoice, name: "mic")
      builder.audioTracks = [audioTrack].compactMap { $0 }

      // see https://github.com/twilio/twilio-video-app-ios/blob/master/VideoApp/VideoApp/Video/Tracks/Camera/CameraSourceFactory.swift
      let options = CameraSourceOptions() { builder in
        if #available(iOS 13, *) {
          builder.orientationTracker = UserInterfaceTracker(scene: UIApplication.shared.keyWindow!.windowScene!)
        }
        // Take a best guess and remove rotation tags using hardware acceleration
        builder.rotationTags = .remove
      }
      let cameraSource = CameraSource(options: options, delegate: nil)

      if let cameraSource = cameraSource {
        let videoTrack = LocalVideoTrack(source: cameraSource, enabled: enabledVideo, name: "camera")
        builder.videoTracks = [videoTrack].compactMap { $0 }
      } else {
        builder.videoTracks = []
      }
    }

    room = TwilioVideoSDK.connect(options: options, delegate: self)
  }

  public func disconnect() {
    room?.disconnect()
    room = nil
  }
}

// MARK: - RoomDelegate

extension TwilioVideoImpl: RoomDelegate {
  public func roomDidConnect(room: Room) {
    print("room connected")
    onRoomDidConnectListener?.onRoomDidConnect()
  }

  public func roomDidDisconnect(room: Room, error: Error?) {
    print("room disconnected")
    onRoomDidDisconnectListener?.onRoomDidDisconnect()
  }

  public func roomDidFailToConnect(room: Room, error: Error) {
    print("room failed to connect")
    onRoomDidFailToConnectListener?.onRoomDidFailToConnect()
  }

  public func participantDidConnect(room: Room, participant: RemoteParticipant) {
    onParticipantDidConnectListener?.onParticipantDidConnect()

    // Not handled participant delegate yet
    // participant.delegate = self
  }

  public func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
    onParticipantDidDisconnectListener?.onParticipantDidDisconnect()
  }
}

// MARK: - RemoteParticipantDelegate

extension TwilioVideoImpl: RemoteParticipantDelegate {

}
