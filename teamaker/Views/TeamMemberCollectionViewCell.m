//
//  TeamMemberCollectionViewCell.m
//  teamaker
//
//  Created by hustlzp on 15/8/27.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TeamMemberCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"

@implementation TeamMemberCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    // 用户头像
    UIImageView *avatarView = [UIImageView new];
    self.userAvatarView = avatarView;
    self.userAvatarView.layer.cornerRadius = 25;
    self.userAvatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:avatarView];
    
    // 用户名
    UILabel *nameLabel = [UILabel new];
    self.userNameLabel = nameLabel;
    self.userNameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(avatarView.mas_bottom);
        make.bottom.equalTo(self.contentView).priorityHigh();
    }];
    
    return self;
}

- (void)updateDataWithUser:(TMUser *)user
{
    [self.userAvatarView setImageWithURL:[NSURL URLWithString:user.avatar]];
    self.userNameLabel.text = user.name;
}

@end
