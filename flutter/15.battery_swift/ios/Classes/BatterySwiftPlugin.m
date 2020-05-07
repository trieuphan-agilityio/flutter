#import "BatterySwiftPlugin.h"
#if __has_include(<battery_swift/battery_swift-Swift.h>)
#import <battery_swift/battery_swift-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "battery_swift-Swift.h"
#endif

@implementation BatterySwiftPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBatterySwiftPlugin registerWithRegistrar:registrar];
}
@end
