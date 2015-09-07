//
//  AddTeamMemberTableViewCell.m
//  teamaker
//
//  Created by hustlzp on 15/9/7.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "AddTeamMemberTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import "TMUser.h"

@interface AddTeamMemberTableViewCell ()

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation AddTeamMemberTableViewCell

+ (NSString *)getReuseIdentifier
{
    return @"eamMemberTableViewCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    self.avatarView = imageView;
    [self.contentView addSubview:imageView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // checkbox
    M13Checkbox *checkbox = [[M13Checkbox alloc] initWithTitle:@"EMPTY"];
    checkbox.strokeColor = [UIColor grayColor];
    self.checkbox = checkbox;
    [self.contentView addSubview:checkbox];
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(imageView.mas_right).offset(10);
    }];
    
    [checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)updateCellWithUserInfo:(TMTeamUserInfo *)userInfo
{
    [self.avatarView setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    self.nameLabel.text = userInfo.user.name;
}

@end
