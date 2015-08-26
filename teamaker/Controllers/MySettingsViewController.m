//
//  MySettingsViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/26.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "MySettingsViewController.h"

@interface MySettingsViewController ()

@end

@implementation MySettingsViewController

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
}

@end
