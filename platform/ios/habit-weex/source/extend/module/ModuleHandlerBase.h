#import <Foundation/Foundation.h>
#import <WeexSDK/WXModuleProtocol.h>


@interface ModuleHandlerBase : NSObject

- (void)handleJsCall:(NSString *)operate data:(NSDictionary *)dic callback:(WXModuleCallback)callback;

@end

