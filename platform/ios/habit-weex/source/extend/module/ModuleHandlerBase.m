#import "ModuleHandlerBase.h"


@implementation ModuleHandlerBase

- (void)handleJsCall:(NSString *)operate data:(NSDictionary *)dic callback:(WXModuleCallback)callback
{
    if (nil == operate || [operate isEqualToString:@""]) {
        if (nil != callback) {
            callback(nil);
        }
        return;
    }
    
    BOOL hasParam = (nil != dic && [dic isKindOfClass:[NSDictionary class]] && [dic count] > 0);
    BOOL hasCallback = (nil != callback);
    
    // - (void)foo:dic withCallback:callback
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:withCallback:", operate]);
    if (hasParam && hasCallback && [self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, NSDictionary *, WXModuleCallback) = (void *)imp;
        func(self, selector, dic, callback);
        return;
    }
    
    // - (void)fooWithCallback:callback
    selector = NSSelectorFromString([NSString stringWithFormat:@"%@WithCallback:", operate]);
    if (!hasParam && hasCallback && [self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, WXModuleCallback) = (void *)imp;
        func(self, selector, callback);
        return;
    }
    
    // - (void)foo:dic
    selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", operate]);
    if (hasParam && [self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, NSDictionary *) = (void *)imp;
        func(self, selector, dic);
        
        if (nil != callback) {
            callback(nil);
        }
        return;
    }
    
    // - (void)foo
    selector = NSSelectorFromString(operate);
    if (!hasParam && [self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
        
        if (nil != callback) {
            callback(nil);
        }
        return;
    }
    
    // not found
    if (nil != callback) {
        callback(nil);
    }
}

@end
