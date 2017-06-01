#import <Foundation/Foundation.h>
#import "ModuleHandlerBase.h"



@interface PaymentManager : ModuleHandlerBase


+ (instancetype)sharedInstance;

- (void)registModule;


- (void)doSomething;

- (void)doSomething:(NSDictionary *)data;

- (void)doSomethingWithCallback:(WXModuleCallback)callback;

- (void)doSomething:(NSDictionary *)data withCallback:(WXModuleCallback)callback;

@end
