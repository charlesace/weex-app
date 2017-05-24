//
//  ViewController.m
//  habit-weex
//
//  Created by Mac on 4/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>


@interface ViewController ()

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;

@end

@implementation ViewController

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
    _instance.frame = self.view.frame;
    
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
    
    [_instance renderWithURL:[NSURL URLWithString:_url] options:@{@"bundleUrl":_url} data:nil];
}


@end
