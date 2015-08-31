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
#import "TMTeam.h"
#import "TMUser.h"
#import "NSDate+FriendlyInterval.h"

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
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAvatarClicked:)];
    gesture.numberOfTapsRequired = 1;
    avatarView.userInteractionEnabled = YES;
    [avatarView addGestureRecognizer:gesture];
    [self.contentView addSubview:avatarView];
    self.userAvatarImageView = avatarView;
    
    // 用户名
    UIButton *userButton = [[UIButton alloc] init];
    userButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userButton setTitleColor:[UIColor colorWithRGBA:0x333333FF] forState:UIControlStateNormal];
//    [userButton addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    userButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:userButton];
    self.userButton = userButton;
    
    // 团队名
    UIButton *teamButton = [[UIButton alloc] init];
    teamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [teamButton setTitleColor:[UIColor colorWithRGBA:0x999999FF] forState:UIControlStateNormal];
//    [teamButton addTarget:self action:@selector(teamButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    teamButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:teamButton];
    self.teamButton = teamButton;
    
    // 内容
    UIView *contentView = [UIView new];
    [self.contentView addSubview:contentView];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        // 文字
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:textLabel];
        self.myTextLabel = textLabel;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        // 打卡
        UILabel *punchLabel = [[UILabel alloc] init];
        punchLabel.numberOfLines = 0;
        punchLabel.lineBreakMode = NSLineBreakByWordWrapping;
        punchLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:punchLabel];
        self.punchLabel = punchLabel;
    }
    
    /* 时间与命令容器 */
    UIView *timeAndCommandsContainer = [UIView new];
    [self.contentView addSubview:timeAndCommandsContainer];
    
    // 时间
    UILabel *timeLable = [UILabel new];
    timeLable.font = [UIFont systemFontOfSize:12];
    [timeAndCommandsContainer addSubview:timeLable];
    timeLable.textColor = [UIColor colorWithRGBA:0x999999FF];
    self.createdAtLabel = timeLable;
    
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
        make.left.equalTo(userButton);
        make.top.equalTo(userButton.mas_bottom).with.offset(5);
        make.height.equalTo(@14).priorityHigh();
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teamButton.mas_bottom);
        make.left.equalTo(userButton);
        make.right.equalTo(self.contentView);
    }];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(contentView);
            make.top.equalTo(contentView).with.offset(6).priorityHigh();
        }];
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        [self.punchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userButton.mas_right).offset(5);
            make.top.equalTo(userButton);
        }];
    }
    
    [timeAndCommandsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(10).priorityHigh();
        make.left.equalTo(userButton);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(timeAndCommandsContainer);
    }];
    
    return self;
}

- (void)updateCellWithFeed:(TMFeed *)feed
{
    NSString *reuseIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
    
    [self.userButton setTitle:feed.user.name forState:UIControlStateNormal];
    self.userButton.tag = feed.userIdValue;
    
    [self.teamButton setTitle:feed.team.name forState:UIControlStateNormal];
    self.teamButton.tag = feed.teamIdValue;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:feed.user.avatar]];
    __weak FeedTableViewCell *cell = self;
    [self.userAvatarImageView setImageWithURLRequest:request placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 cell.userAvatarImageView.image = image;
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 NSLog(@"%@", error);
                                             }];
    self.userAvatarImageView.tag = feed.userIdValue;
    
    self.createdAtLabel.text = [feed.createdAt friendlyInterval];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        self.myTextLabel.text = feed.text;
        self.myTextLabel.tag = feed.idValue;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        self.punchLabel.text = [[NSString alloc] initWithFormat:@": %@", feed.punch];
        self.punchLabel.tag = feed.idValue;
    }
}

- (void)userButtonClicked:(UIButton *)sender
{
    [self.delegate redirectToUserProfile:[NSNumber numberWithLong:sender.tag]];
}

- (void)userAvatarClicked:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.delegate redirectToUserProfile:[NSNumber numberWithLong:gestureRecognizer.view.tag]];
}

- (void)teamButtonClicked:(UIButton *)sender
{
    [self.delegate redirectToTeamProfile:[NSNumber numberWithLong:sender.tag]];
}

@end
