#import "AppBlockRitPlugin.h"
#if __has_include(<app_block_rit/app_block_rit-Swift.h>)
#import <app_block_rit/app_block_rit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_block_rit-Swift.h"
#endif

@implementation AppBlockRitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppBlockRitPlugin registerWithRegistrar:registrar];
}
@end
