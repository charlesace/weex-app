//
//  WeexViewController.h
//  habit-weex
//
//  Created by Mac on 4/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeexSDK/WeexSDK.h>

@interface WeexViewController : WXBaseViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *options;

@end

