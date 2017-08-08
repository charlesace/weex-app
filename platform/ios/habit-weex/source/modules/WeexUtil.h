//
//  WeexUtil.h
//  habit
//  weex调用通用模块
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleHandlerBase.h"


@interface WeexUtil : ModuleHandlerBase

+ (instancetype)sharedInstance;

- (void)registModule;


@end
