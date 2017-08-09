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
#import "VersionManager.h"
#import "LaunchViewController.h"


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

- (void)onLaunch
{
    // weex init
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    
    // modules called by js
    [self registModules];
    
    // check version & open weex view
    [self initLaunchView];
    [[VersionManager sharedInstance] checkAppVersion:^{
        [self initMainView];
    }];
}

- (void)initLaunchView
{
    LaunchViewController *controller = [[LaunchViewController alloc] init];
    _navController = [[WXRootViewController alloc] initWithRootViewController:controller];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = _navController;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
}

- (void)initMainView
{
    // js entrance
    WeexViewController *controller = [[WeexViewController alloc] init];
    controller.url = @"main.js";
    [_navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
}

- (void)registModules
{
    [WXEventModule initModule];
    [[WeexUtil sharedInstance] registModule];
}

@end
