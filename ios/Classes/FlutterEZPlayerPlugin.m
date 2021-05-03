#import "FlutterEZPlayerPlugin.h"
#if __has_include(<flutter_ezplayer/flutter_ezplayer-Swift.h>)
#import <flutter_ezplayer/flutter_ezplayer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_ezplayer-Swift.h"
#endif

@implementation FlutterEZPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterEZPlayerPlugin registerWithRegistrar:registrar];
}
@end
