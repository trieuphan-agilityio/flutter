#import "TwilioVideoCallPlugin.h"
#if __has_include(<twilio_video_call/twilio_video_call-Swift.h>)
#import <twilio_video_call/twilio_video_call-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "twilio_video_call-Swift.h"
#endif

@implementation TwilioVideoCallPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTwilioVideoCallPlugin registerWithRegistrar:registrar];
}
@end
