//
//  MyProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/21.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "MyProfileViewController.h"
#import "TMUser.h"

@implementation MyProfileViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.navigationItem.title = [[TMUser getLoggedInUser] name];
    self.view.backgroundColor = [UIColor grayColor];
}

@end
