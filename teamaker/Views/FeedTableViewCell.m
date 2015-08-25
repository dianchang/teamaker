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
    userButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userButton setTitleColor:[UIColor colorWithRGBA:0x333333FF] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(userButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    userButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:userButton];
    self.userButton = userButton;
    
    // 团队名
    UIButton *teamButton = [[UIButton alloc] init];
    teamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [teamButton setTitleColor:[UIColor colorWithRGBA:0xAAAAAAFF] forState:UIControlStateNormal];
    [teamButton addTarget:self action:@selector(teamButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    teamButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:teamButton];
    self.teamButton = teamButton;
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        // 文字
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:textLabel];
        self.myTextLabel = textLabel;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        // 打卡
        UILabel *punchLabel = [[UILabel alloc] init];
        punchLabel.numberOfLines = 0;
        punchLabel.lineBreakMode = NSLineBreakByWordWrapping;
        punchLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:punchLabel];
        self.punchLabel = punchLabel;
    }
    
//    // 时间与命令
//    UIView *timeAndCommandsView = [[UIView alloc] init];
//    [self.contentView addSubview:timeAndCommandsView];
//    // 时间
    
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
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(teamButton);
            make.top.equalTo(teamButton.mas_bottom).with.offset(6);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        [self.punchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(teamButton);
            make.top.equalTo(teamButton.mas_bottom).with.offset(6);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
    
    return self;
}

- (void)updateCellWithFeed:(TMFeed *)feed
{
    NSString *reuseIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
    
    [self.userButton setTitle:feed.user.name forState:UIControlStateNormal];
    self.userButton.tag = feed.idValue;
    
    [self.teamButton setTitle:feed.team.name forState:UIControlStateNormal];
    self.teamButton.tag = feed.idValue;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:feed.user.avatar]];
    __weak FeedTableViewCell *cell = self;
    [self.userAvatarImageView setImageWithURLRequest:request placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 cell.userAvatarImageView.image = image;
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 NSLog(@"%@", error);
                                             }];
    self.userAvatarImageView.tag = feed.idValue;
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        self.myTextLabel.text = feed.text;
        self.myTextLabel.tag = feed.idValue;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        self.punchLabel.text = feed.punch;
        self.punchLabel.tag = feed.idValue;
    }
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
