//
//  AppManager.h
//  habit
//  应用管理器
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AppManager : NSObject

+ (instancetype)sharedInstance;

- (void)onLaunch:(UIWindow *)window;


@end
