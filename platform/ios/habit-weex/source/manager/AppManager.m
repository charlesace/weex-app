//
//  AppManager.m
//  habit
//  应用管理器
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//

#import "AppManager.h"
#import <WeexSDK/WeexSDK.h>
#import <WeexSDK/WXSDKEngine.h>
#import <WeexSDK/WXDebugTool.h>
#import <WeexSDK/WXLog.h>
#import <WeexSDK/WXAppConfiguration.h>
#import "WXEventModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "WeexViewController.h"
#import "WeexUtil.h"


@implementation AppManager

+ (instancetype)sharedInstance
{
    static AppManager *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[AppManager alloc] init];
    });
    return instance;
}

- (void)onLaunch:(UIWindow *)window
{
    // weex init
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    
    // js entrance
    WeexViewController *controller = [[WeexViewController alloc] init];
    controller.url = @"main.js";
    window.rootViewController = [[WXRootViewController alloc] initWithRootViewController:controller];
    
    // modules called by js
    [self registModules];
}

- (void)registModules
{
    [WXEventModule initModule];
    [[WeexUtil sharedInstance] registModule];
}

@end
