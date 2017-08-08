//
//  LaunchViewController.m
//  habit
//
//  Created by hzm on 17-8-8.
//  Copyright (c) 2017年 custom. All rights reserved.
//


#import "LaunchViewController.h"


@implementation LaunchViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_indicator startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_indicator stopAnimating];
}

@end
