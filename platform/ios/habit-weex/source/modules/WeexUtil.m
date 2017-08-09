//
//  WeexUtil.m
//  habit
//  weex调用通用模块
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//

#import "WeexUtil.h"
#import "WXEventModule.h"
#import "AppMacro.h"
#import "VersionManager.h"


@interface WeexUtil()


@end


@implementation WeexUtil

+ (instancetype)sharedInstance
{
    static WeexUtil *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[WeexUtil alloc] init];
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

- (void)initAppInfoWithCallback:(WXModuleCallback)callback
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithBool:IS_RELEASE_VERSION] forKey:@"release"];
    [dic setValue:[[VersionManager sharedInstance] localVersion] forKey:@"version"];
    [dic setValue:[[VersionManager sharedInstance] applicationPath] forKey:@"appPath"];
    [dic setValue:[[VersionManager sharedInstance] patchPath] forKey:@"patchPath"];
    callback(dic);
}

- (void)isFileExist:(NSDictionary *)data withCallback:(WXModuleCallback)callback
{
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:data[@"file"]];
    callback([NSNumber numberWithBool:ret]);
}


@end
