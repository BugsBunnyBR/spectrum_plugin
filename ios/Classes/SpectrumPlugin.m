#import "SpectrumPlugin.h"
#import <spectrum_plugin/spectrum_plugin-Swift.h>

@implementation SpectrumPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSpectrumPlugin registerWithRegistrar:registrar];
}
@end
