//
//  VersionManager.h
//  版本管理器
//  Created by hzm on 17/07/13.
//  Copyright (c) 2017年 winupon. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VersionManager : NSObject

typedef void (^CheckFinishBlock) ();

typedef NS_ENUM (NSUInteger, VersionComparisonResult) {
    VersionCompareEqual     = 0,
    VersionCompareHigh      = 1,
    VersionCompareLow       = 2
};


+ (instancetype)sharedInstance;


- (void)checkAppVersion:(CheckFinishBlock)complete;

- (NSString *)localVersion;

- (NSString *)patchPath;


@end
