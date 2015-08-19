//
//  LocationViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "LocationViewController.h"
#import "Masonry.h"
#import "ComposeViewControllerProtocol.h"

@interface LocationViewController () <ComposeViewControllerProtocol>

@end

@implementation LocationViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor greenColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Location";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(20);
    }];
}

- (void)resetLayout
{
}

@end
