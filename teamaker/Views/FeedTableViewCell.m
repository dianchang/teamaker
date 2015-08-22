//
//  FeedTableViewCell.m
//  teamaker
//
//  Created by hustlzp on 15/8/22.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "UIColor+Helper.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"

static NSString *const textCellReuseIdentifier = @"TextCell";
static NSString *const imageCellReuseIdentifier = @"ImageCell";
static NSString *const punchCellReuseIdentifier = @"PunchCell";
static NSString *const locationCellReuseIdentifier = @"LocationCell";

@interface FeedTableViewCell()
@end

@implementation FeedTableViewCell

+ (NSString *)getResuseIdentifierByFeed:(TMFeed *)feed
{
    if ([feed.kind isEqualToString:@"text"]) {
        return textCellReuseIdentifier;
    } else if ([feed.kind isEqualToString:@"image"]) {
        return imageCellReuseIdentifier;
    } else if ([feed.kind isEqualToString:@"punch"]) {
        return punchCellReuseIdentifier;
    } else {
        return locationCellReuseIdentifier;
    }
}

+ (void)registerClassForCellReuseIdentifierOnTableView:(UITableView *)tableView
{
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:textCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:imageCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:locationCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:punchCellReuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    // 用户头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.layer.cornerRadius = 15;
    avatarView.layer.masksToBounds = YES;
    [self.contentView addSubview:avatarView];
    self.userAvatarImageView = avatarView;
    
    // 用户名
    UIButton *userButton = [[UIButton alloc] init];
    [userButton setTitleColor:[UIColor colorWithRGBA:0x333333FF] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    userButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:userButton];
    self.userButton = userButton;
    
    // 团队名
    UIButton *teamButton = [[UIButton alloc] init];
    [teamButton setTitleColor:[UIColor colorWithRGBA:0xAAAAAAFF] forState:UIControlStateNormal];
    [teamButton addTarget:self action:@selector(teamButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    teamButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:teamButton];
    self.teamButton = teamButton;
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.equalTo(@30).priorityHigh();
        make.height.equalTo(@30).priorityHigh();
    }];
    
    [userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.height.equalTo(@18).priorityHigh();
    }];
    
    [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(15);
        make.top.equalTo(userButton.mas_bottom).with.offset(5);
        make.height.equalTo(@14).priorityHigh();
        make.bottom.equalTo(self.contentView).with.offset(-15);
    }];
    
    return self;
}

- (void)updateCellWithFeed:(TMFeed *)feed
{
    [self.userButton setTitle:feed.user forState:UIControlStateNormal];
    self.userButton.tag = feed.id;
    
    [self.teamButton setTitle:feed.team forState:UIControlStateNormal];
    self.teamButton.tag = feed.id;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:feed.userAvatar]];
    __weak FeedTableViewCell *cell = self;
    [self.userAvatarImageView setImageWithURLRequest:request placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 cell.userAvatarImageView.image = image;
                                                 NSLog(@"hehe");
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 NSLog(@"%@", error);
                                             }];
    self.userAvatarImageView.tag = feed.id;
}

- (void)userButtonClicked:(UIButton *)sender
{
    [self.delegate userButtonClicked:sender];
}

- (void)teamButtonClicked:(UIButton *)sender
{
    [self.delegate teamButtonClicked:sender];
}

@end
