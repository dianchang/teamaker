//
//  MyDetailsViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/26.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "MyDetailsViewController.h"

@interface MyDetailsViewController ()

@end

@implementation MyDetailsViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
}

@end
