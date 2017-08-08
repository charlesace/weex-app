//
//  WeexUtil.m
//  habit
//  weex调用通用模块
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//

#import "WeexUtil.h"
#import "WXEventModule.h"


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


@end
