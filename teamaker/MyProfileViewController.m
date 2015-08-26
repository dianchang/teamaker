//
//  MyProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/21.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "MyProfileViewController.h"
#import "TMUser.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import <MagicalRecord/MagicalRecord.h>

@interface MyProfileViewController ()

@property (strong, nonatomic) TMUser *loggedInUser;

@end

@implementation MyProfileViewController

- (instancetype)init
{
    self = [super init];
    return self;
}

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser getLoggedInUser];
    }
    
    return _loggedInUser;
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *avatarView = [UIImageView new];
    [avatarView setImageWithURL:[NSURL URLWithString:self.loggedInUser.avatar]];
    avatarView.layer.cornerRadius = 30;
    avatarView.layer.masksToBounds = YES;
    [self.view addSubview:avatarView];
    
    UILabel *userLable = [UILabel new];
    userLable.text = self.loggedInUser.name;
    userLable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:userLable];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.top.equalTo(self.view).offset(70);
    }];
    
    [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(avatarView.mas_bottom).offset(10);
    }];
}

@end
