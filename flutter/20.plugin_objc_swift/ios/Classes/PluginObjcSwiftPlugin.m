#import "PluginObjcSwiftPlugin.h"
#import "messages.h"
#if __has_include(<plugin_objc_swift/plugin_objc_swift-Swift.h>)
#import <plugin_objc_swift/plugin_objc_swift-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin_objc_swift-Swift.h"
#endif

@implementation PluginObjcSwiftPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPluginObjcSwiftPlugin registerWithRegistrar:registrar];
}
@end
