import 'package:twilio_video_call/twilio_video_call.dart';
import 'package:video_call_platform_interface/video_call_platform_interface.dart';

abstract class VideoCallServiceLocator {
  VideoCallApi get videoCallApi;
}

class VideoCallService {
  VideoCallApi videoCallApi() => new TwilioVideoCallApi();
}
