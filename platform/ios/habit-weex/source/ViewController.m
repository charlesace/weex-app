//
//  ViewController.m
//  habit-weex
//
//  Created by Mac on 4/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import <WeexSDK/WeexSDK.h>


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"哈哈哈" forKey:@"param1"];
        [params setValue:@"呵呵呵" forKey:@"param2"];
        [params setValue:[NSNumber numberWithInteger:999] forKey:@"param3"];
//        [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"ontest" params:params domChanges:nil];
        
        [_instance fireGlobalEvent:@"geolocation" params:params];
    });
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
    
    [_instance renderWithURL:[NSURL URLWithString:_url] options:_options data:nil];
}


@end
