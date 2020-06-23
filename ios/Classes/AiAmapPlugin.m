#import "AiAmapPlugin.h"
#if __has_include(<ai_amap/ai_amap-Swift.h>)
#import <ai_amap/ai_amap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ai_amap-Swift.h"
#endif

@implementation AiAmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAiAmapPlugin registerWithRegistrar:registrar];
}
@end
