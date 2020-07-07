import Foundation
import TwilioVideo

public struct FLTRoom {
  let sid: String
  let name: String
  let numOfRemoteParticipants: Int
  
  init(_ room: Room) {
    self.sid = room.sid
    self.name = room.name
    self.numOfRemoteParticipants = room.remoteParticipants.count
  }
  
  func toJson() -> [String: Any] {
    return [
      "sid": sid,
      "name": name,
      "numOfRemoteParticipants": numOfRemoteParticipants,
    ]
  }
}

public protocol TwilioVideo {
  func connect(accessToken: String, roomName: String, enabledVoice: Bool, enabledVideo: Bool) -> FLTRoom
  func disconnect()
  
  func getLocalParticipant() -> LocalParticipant?
  func getRemoteParticipant() -> RemoteParticipant?

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

  public func connect(accessToken: String, roomName: String, enabledVoice: Bool, enabledVideo: Bool) -> FLTRoom {
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

    let mRoom = TwilioVideoSDK.connect(options: options, delegate: self)
    // keep a reference for future use.
    self.room = mRoom
    
    return FLTRoom(mRoom)
  }

  public func disconnect() {
    room?.disconnect()
    room = nil
  }
  
  public func getLocalParticipant() -> LocalParticipant? {
    return room?.localParticipant
  }
  
  public func getRemoteParticipant() -> RemoteParticipant? {
    // support 1-to-1 call for now.
    return room?.remoteParticipants.first
  }
}

// MARK: - RoomDelegate

extension TwilioVideoImpl: RoomDelegate {
  public func roomDidConnect(room: Room) {
    let fltRoom = FLTRoom(room)
    onRoomDidConnectListener?.onRoomDidConnect(fltRoom)
  }

  public func roomDidDisconnect(room: Room, error: Error?) {
    let fltRoom = FLTRoom(room)
    onRoomDidDisconnectListener?.onRoomDidDisconnect(fltRoom)
  }

  public func roomDidFailToConnect(room: Room, error: Error) {
    let fltRoom = FLTRoom(room)
    onRoomDidFailToConnectListener?.onRoomDidFailToConnect(fltRoom)
  }

  public func participantDidConnect(room: Room, participant: RemoteParticipant) {
    let fltRoom = FLTRoom(room)
    onParticipantDidConnectListener?.onParticipantDidConnect(fltRoom)

    // Not handled participant delegate yet
    // participant.delegate = self
  }

  public func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
    let fltRoom = FLTRoom(room)
    onParticipantDidDisconnectListener?.onParticipantDidDisconnect(fltRoom)
  }
}

// MARK: - RemoteParticipantDelegate

extension TwilioVideoImpl: RemoteParticipantDelegate {

}
