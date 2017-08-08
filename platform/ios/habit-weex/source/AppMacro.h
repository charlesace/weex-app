//
//  AppMacro.h
//  habit
//  应用的常量
//
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//


#ifdef HABIT_RELEASE
    // 外网正式
    #define IS_RELEASE_VERSION YES

    // 获取版本信息的xml地址
    #define VAESION_CHECK_URL   @"https://www.baidu.com/habit/release/ios"

#else
    // 内网测试
    #define IS_RELEASE_VERSION NO

    // 获取版本信息的xml地址
    #define VAESION_CHECK_URL   @"https://www.baidu.com/habit/test/ios"

#endif

