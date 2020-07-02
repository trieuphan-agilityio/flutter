#import "TwilioVideoPlugin.h"
#if __has_include(<twilio_video/twilio_video-Swift.h>)
#import <twilio_video/twilio_video-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "twilio_video-Swift.h"
#endif

@implementation TwilioVideoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTwilioVideoPlugin registerWithRegistrar:registrar];
}
@end
