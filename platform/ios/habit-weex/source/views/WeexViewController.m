//
//  WeexViewController.m
//  habit-weex
//
//  Created by Mac on 4/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "WeexViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import <WeexSDK/WeexSDK.h>
#import "VersionManager.h"


@interface WeexViewController()<UINavigationControllerDelegate>

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;

@end


@implementation WeexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self render];
}

- (void)dealloc
{
    [_instance destroyInstance];
}

- (void)render
{
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        if (nil != weakSelf.weexView) {
            [weakSelf.weexView removeFromSuperview];
        }
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    
    _instance.renderFinish = ^(UIView *view) {
        //process renderFinish
    };
    
    NSString *absUrl = [NSString stringWithFormat:@"file://%@/bundlejs/%@", [NSBundle mainBundle].bundlePath, _url];
    NSString *patchPath = [[VersionManager sharedInstance] patchPath];
    if (![patchPath isEqualToString:@""]) {
        NSString *pacthFile = [NSString stringWithFormat:@"%@/bundlejs/%@", patchPath, _url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:pacthFile]) {
            absUrl = [NSString stringWithFormat:@"file://%@", pacthFile];
        }
    }
    [_instance renderWithURL:[NSURL URLWithString:absUrl] options:_options data:nil];
}

@end
