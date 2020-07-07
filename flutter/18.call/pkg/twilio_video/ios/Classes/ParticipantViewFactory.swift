
import Flutter
import Foundation
import TwilioVideo

class ParticipantViewFactory: NSObject, FlutterPlatformViewFactory {
    public static let VIEW_ID: String = "com.example/participant_view"
    private var twilioVideo: TwilioVideo

    init(_ twilioVideo: TwilioVideo) {
        self.twilioVideo = twilioVideo
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    public func create(
      withFrame frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?
    ) -> FlutterPlatformView {
      guard let localParticipant = twilioVideo.getLocalParticipant() else {
        return EmptyView()
      }
      
      // default video is local participant
      var videoTrack: VideoTrack? = localParticipant.localVideoTracks.first?.localTrack
      
      // front camera should use a mirror
      var shouldMirror = false
      
      if let params = args as? [String: Any] {
        shouldMirror = params["mirror"] as? Bool ?? false
        
        // Check if requesting remote participant's video.
        // If so, use remote participant video track instead of the local one.
        let isRemoteParticipant = params["isRemoteParticipant"] as? Bool ?? false
        if isRemoteParticipant {
          if let remoteVideoTrack = twilioVideo.getRemoteParticipant()?.remoteVideoTracks.first?.remoteTrack {
            videoTrack = remoteVideoTrack
          }
        }
      }
      
      guard let unwrappedVideoTrack = videoTrack else {
        return EmptyView()
      }
      
      let videoView = VideoView(frame: frame)
      videoView.shouldMirror = shouldMirror
      videoView.contentMode = .scaleAspectFill
      
      return ParticipantView(videoView, videoTrack: unwrappedVideoTrack)
  }
}

class EmptyView: NSObject, FlutterPlatformView {
  public func view() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    return view
  }
}




