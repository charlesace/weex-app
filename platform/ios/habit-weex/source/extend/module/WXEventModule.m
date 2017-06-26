/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXEventModule.h"
#import <WeexSDK/WXBaseViewController.h>


static NSMutableDictionary *registedModules = nil;



@implementation WXEventModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(openURL:))
WX_EXPORT_METHOD(@selector(jsCall: operate: data: callback:))


+ (void)initModule
{
    if (nil == registedModules) {
        registedModules = [[NSMutableDictionary alloc] init];
    }
}

+ (void)registModule:(ModuleHandlerBase *)module
{
    [registedModules setObject:module forKey:NSStringFromClass([module class])];
}

- (void)jsCall:(NSString *)moduleName operate:(NSString *)operate data:(NSDictionary *)dic callback:(WXModuleCallback)callback
{
    NSObject *obj = [registedModules objectForKey:moduleName];
    if (nil == obj) {
        if (nil != callback) {
            callback(nil);
        }
        return;
    }
    
    ModuleHandlerBase *module = (ModuleHandlerBase *)obj;
    [module handleJsCall:operate data:dic callback:callback];
}



- (void)openURL:(NSString *)url
{
//    NSString *newURL = url;
//    if ([url hasPrefix:@"//"]) {
//        newURL = [NSString stringWithFormat:@"http:%@", url];
//    } else if (![url hasPrefix:@"http"]) {
//        // relative path
//        newURL = [NSURL URLWithString:url relativeToURL:weexInstance.scriptURL].absoluteString;
//    }
//    else if ([url hasPrefix:@"http://Users/examples/build/vue/"]) {
//        NSRange range = [url rangeOfString:@"http://Users/examples/build/vue/"];
//        NSString *file = [url substringFromIndex:range.length];
//        newURL = [NSString stringWithFormat:@"file://%@/bundlejs/%@", [NSBundle mainBundle].bundlePath, file];
//    }
//    
//    ViewController *controller = [[ViewController alloc] init];
//    controller.url = newURL;
//    [[weexInstance.viewController navigationController] pushViewController:controller animated:YES];
}

@end

