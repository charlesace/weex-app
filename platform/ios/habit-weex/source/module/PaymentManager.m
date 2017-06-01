#import "PaymentManager.h"
#import "WXEventModule.h"


@implementation PaymentManager

+ (instancetype)sharedInstance
{
    static PaymentManager *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[PaymentManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)registModule
{
    [WXEventModule registModule:self];
}

- (void)doSomething
{
    NSLog(@"doSomething");
}

- (void)doSomething:(NSDictionary *)data
{
    NSLog(@"doSomething data: %@", data);
}

- (void)doSomethingWithCallback:(WXModuleCallback)callback
{
    NSLog(@"doSomethingWithCallback");
    if (nil != callback) {
        callback(nil);
    }
}

- (void)doSomething:(NSDictionary *)data withCallback:(WXModuleCallback)callback
{
    NSLog(@"doSomething data withCallback : %@", data);
    if (nil != callback) {
        callback(nil);
    }
}

@end
