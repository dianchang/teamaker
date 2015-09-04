//
//  FeedTableViewCell.m
//  teamaker
//
//  Created by hustlzp on 15/8/22.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FeedTableViewCell.h"
#import "UIColor+Helper.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import "TMTeam.h"
#import "TMUser.h"
#import "IonIcons.h"
#import "NSDate+FriendlyInterval.h"
#import "UIColor+Helper.h"

static NSString * const shareCellReuseIdentifier = @"shareCell";
static NSString * const textCellReuseIdentifier = @"TextCell";
static NSString * const imageCellReuseIdentifier = @"ImageCell";
static NSString * const punchCellReuseIdentifier = @"PunchCell";
static NSString * const locationCellReuseIdentifier = @"LocationCell";

@interface FeedTableViewCell()

@property (strong, nonatomic) UIButton *commandButton;
@property (strong, nonatomic) UIView* commandsToolbar;
@property (strong, nonatomic) TMFeed *feed;

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
    } else if ([feed.kind isEqualToString:@"location"]){
        return locationCellReuseIdentifier;
    } else {
        return shareCellReuseIdentifier;
    }
}

+ (void)registerClassForCellReuseIdentifierOnTableView:(UITableView *)tableView
{
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:textCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:imageCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:locationCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:punchCellReuseIdentifier];
    [tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:shareCellReuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UITapGestureRecognizer *gestureRecognizerForCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetLayout)];
    gestureRecognizerForCell.numberOfTapsRequired = 1;
    [self addGestureRecognizer:gestureRecognizerForCell];
    
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
    teamButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:teamButton];
    self.teamButton = teamButton;
    
    // 内容
    UIView *feedContentView = [UIView new];
    [self.contentView addSubview:feedContentView];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        // 文字
        UILabel *textLabel = [UILabel new];
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.font = [UIFont systemFontOfSize:14];
        [feedContentView addSubview:textLabel];
        self.myTextLabel = textLabel;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        // 打卡
        UILabel *punchLabel = [UILabel new];
        punchLabel.numberOfLines = 0;
        punchLabel.lineBreakMode = NSLineBreakByWordWrapping;
        punchLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:punchLabel];
        self.punchLabel = punchLabel;
    } else if ([reuseIdentifier isEqualToString:imageCellReuseIdentifier]) {
        // 图片
        UIImageView *imageView = [UIImageView new];
        self.feedImageView = imageView;
        [feedContentView addSubview:imageView];
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
    
    // 操作
    UIButton *commandButton = [UIButton new];
    UIImage *commandButtonImage = [IonIcons imageWithIcon:ion_navicon_round iconColor:[UIColor grayColor] iconSize:15 imageSize:CGSizeMake(45.0f, 40.0f)];
    [commandButton setImage:commandButtonImage forState:UIControlStateNormal];
    [timeAndCommandsContainer addSubview:commandButton];
    self.commandButton = commandButton;
    [commandButton addTarget:self action:@selector(switchCommandsToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.height.equalTo(@18);
    }];
    
    [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userButton);
        make.top.equalTo(userButton.mas_bottom).with.offset(5);
        make.height.equalTo(@14);
    }];
    
    [feedContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teamButton.mas_bottom);
        make.left.equalTo(userButton);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(feedContentView);
            make.top.equalTo(feedContentView).with.offset(6);
        }];
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        [self.punchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userButton.mas_right).offset(5);
            make.top.equalTo(userButton);
        }];
    } else if ([reuseIdentifier isEqualToString:imageCellReuseIdentifier]) {
        [self.feedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(feedContentView);
            make.top.equalTo(feedContentView).offset(10);
        }];
    }
    
    [timeAndCommandsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedContentView.mas_bottom).priorityHigh();
        make.left.equalTo(userButton);
        make.right.bottom.equalTo(self.contentView);
    }];
    
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(timeAndCommandsContainer);
    }];
    
    [commandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(timeAndCommandsContainer);
    }];
        
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.myTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.myTextLabel.frame);
}

/**
 *  更新cell的数据
 *
 *  @param feed <#feed description#>
 */
- (void)updateCellWithFeed:(TMFeed *)feed
{
    self.feed = feed;
    NSString *reuseIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
    
    // 用户名
    [self.userButton setTitle:feed.user.name forState:UIControlStateNormal];
    self.userButton.tag = feed.userIdValue;
    
    // 团队名
    [self.teamButton setTitle:feed.team.name forState:UIControlStateNormal];
    self.teamButton.tag = feed.teamIdValue;
    
    // 用户头像
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
    
    // 时间
    self.createdAtLabel.text = [feed.createdAt friendlyInterval];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        // 文字
        self.myTextLabel.text = feed.text;
        self.myTextLabel.tag = feed.idValue;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        // 打卡
        self.punchLabel.text = [[NSString alloc] initWithFormat:@": %@", feed.punch];
        self.punchLabel.tag = feed.idValue;
    } else if ([reuseIdentifier isEqualToString:imageCellReuseIdentifier]) {
        // 图片
        UIImage *image = [UIImage imageWithData:feed.image];
        self.feedImageView.image = image;
        [self.feedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            NSInteger imageWidth = 100;
            make.width.equalTo([NSNumber numberWithLong:imageWidth]);
            make.height.equalTo([NSNumber numberWithFloat:image.size.height * imageWidth / image.size.width]);
        }];
        self.feedImageView.tag = feed.idValue;
    }
}

- (void)userButtonClicked:(UIButton *)sender
{
    [self.delegate redirectToUserProfile:[NSNumber numberWithLong:sender.tag]];
}

- (void)userAvatarClicked:(UITapGestureRecognizer *)gestureRecognizer
{
    [self hideCommandsToolbar];
    [self.delegate redirectToUserProfile:[NSNumber numberWithLong:gestureRecognizer.view.tag]];
}

// 弹出命令工具栏
- (void)switchCommandsToolbar
{
    if ([self.commandsToolbar superview]) {
        [self hideCommandsToolbar];
    } else {
        [self.contentView addSubview:self.commandsToolbar];
        [self.commandsToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.commandButton);
            make.right.equalTo(self.commandButton.mas_left).offset(8);
        }];
    }
}

// 隐藏命令工具栏
- (void)hideCommandsToolbar
{
    [self.commandsToolbar removeFromSuperview];
}

+ (CGFloat)calculateCellHeightWithFeed:(TMFeed *)feed
{
    FeedTableViewCell *sizingCell;
    static FeedTableViewCell *imageCell;
    static FeedTableViewCell *punchCell;
    static FeedTableViewCell *textCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellReuseIdentifier];
        punchCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:punchCellReuseIdentifier];
        textCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellReuseIdentifier];
    });
    
    NSString *reuseIdentifier = [self getResuseIdentifierByFeed:feed];
    
    if ([reuseIdentifier isEqualToString:imageCellReuseIdentifier]) {
        sizingCell = imageCell;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        sizingCell = punchCell;
    } else {
        sizingCell = textCell;
    }
    
    [sizingCell updateCellWithFeed:feed];
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

#pragma mark - getters & setters

- (UIView *)commandsToolbar
{
    if (!_commandsToolbar) {
        _commandsToolbar = [UIView new];
        _commandsToolbar.backgroundColor = [UIColor colorWithRGBA:0x333333FF];
        _commandsToolbar.layer.cornerRadius = 2;
        _commandsToolbar.layer.masksToBounds = YES;
        
        // 星标
        UIButton *starButton = [UIButton new];
        [starButton setTitle:@"星标" forState:UIControlStateNormal];
        [starButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        starButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [starButton addTarget:self action:@selector(starFeed) forControlEvents:UIControlEventTouchUpInside];
        [_commandsToolbar addSubview:starButton];
        
        // 分隔符
        UIView *firstDivider = [UIView new];
        firstDivider.backgroundColor = [UIColor colorWithRGBA:0x555555FF];
        [_commandsToolbar addSubview:firstDivider];
        
        // 赞
        UIButton *likeButton = [UIButton new];
        [likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [likeButton addTarget:self action:@selector(likeFeed) forControlEvents:UIControlEventTouchUpInside];
        [_commandsToolbar addSubview:likeButton];
        
        // 分隔符
        UIView *secondDivider = [UIView new];
        secondDivider.backgroundColor = [UIColor colorWithRGBA:0x555555FF];
        [_commandsToolbar addSubview:secondDivider];
        
        // 评论
        UIButton *commentButton = [UIButton new];
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [commentButton addTarget:self action:@selector(commentFeed) forControlEvents:UIControlEventTouchUpInside];
        [_commandsToolbar addSubview:commentButton];
        
        // 约束
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.bottom.equalTo(_commandsToolbar);
            make.width.equalTo(@60);
            make.height.equalTo(@35);
        }];
        
        [firstDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commandsToolbar).offset(8);
            make.bottom.equalTo(_commandsToolbar).offset(-8);
            make.width.equalTo(@1);
            make.left.equalTo(starButton.mas_right);
            make.right.equalTo(likeButton.mas_left);
        }];
        
        [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(_commandsToolbar);
            make.size.equalTo(starButton);
        }];
        
        [secondDivider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commandsToolbar).offset(8);
            make.bottom.equalTo(_commandsToolbar).offset(-8);
            make.width.equalTo(@1);
            make.left.equalTo(likeButton.mas_right);
            make.right.equalTo(commentButton.mas_left);
        }];
        
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.and.bottom.equalTo(_commandsToolbar);
            make.size.equalTo(starButton);
        }];
    }
    
    return _commandsToolbar;
}

// 打星标
- (void)starFeed
{
    [self.delegate starFeed:self.feed];
    [self hideCommandsToolbar];
}

// 赞
- (void)likeFeed
{
    [self.delegate likeFeed:self.feed];
    [self hideCommandsToolbar];
}

// 评论
- (void)commentFeed
{
    [self.delegate commentFeed:self.feed];
    [self hideCommandsToolbar];
}

// 重置布局
- (void)resetLayout
{
    [self hideCommandsToolbar];
}

@end
