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
#import <MagicalRecord/MagicalRecord.h>
#import "UIColor+Helper.h"

static NSString * const shareCellReuseIdentifier = @"shareCell";
static NSString * const textCellReuseIdentifier = @"TextCell";
static NSString * const imageCellReuseIdentifier = @"ImageCell";
static NSString * const punchCellReuseIdentifier = @"PunchCell";
static NSString * const locationCellReuseIdentifier = @"LocationCell";

@interface FeedTableViewCell()

@property (strong, nonatomic) UILabel *myTextLabel;
@property (strong, nonatomic) UILabel *punchLabel;

@property (strong, nonatomic) UIImageView *feedImageView;
@property (strong, nonatomic) UIView *feedImagePreviewBackdropView;
@property (strong, nonatomic) UIImageView *feedImagePreviewImageView;
@property (nonatomic) CGRect feedImagePreviewImageViewOriginalFrame;

@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UILabel *shareTitleLabel;

@end

@implementation FeedTableViewCell



/**
 *  初始化cell
 *
 *  @param style           <#style description#>
 *  @param reuseIdentifier <#reuseIdentifier description#>
 *
 *  @return <#return value description#>
 */
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
    self.feedContentView = feedContentView;
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
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gestureForImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        gestureForImageView.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:gestureForImageView];
        [feedContentView addSubview:imageView];
    } else if ([reuseIdentifier isEqualToString:shareCellReuseIdentifier]) {
        // 分享
        UIView *shareView = [UIView new];
        self.shareView = shareView;
        shareView.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
        [feedContentView addSubview:shareView];
        UITapGestureRecognizer *gestureForShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewClicked:)];
        gestureForShare.numberOfTapsRequired = 1;
        shareView.userInteractionEnabled = YES;
        [shareView addGestureRecognizer:gestureForShare];

        // 分享标题
        UILabel *shareTitleLabel = [UILabel new];
        shareTitleLabel.numberOfLines = 0;
        shareTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        shareTitleLabel.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:shareTitleLabel];
        self.shareTitleLabel = shareTitleLabel;
    }
    
    /* 时间与命令容器 */
    UIView *timeAndCommandsView = [UIView new];
    self.timeAndCommandsView = timeAndCommandsView;
    [self.contentView addSubview:timeAndCommandsView];
    
    // 时间
    UILabel *timeLable = [UILabel new];
    timeLable.font = [UIFont systemFontOfSize:12];
    [timeAndCommandsView addSubview:timeLable];
    timeLable.textColor = [UIColor colorWithRGBA:0x999999FF];
    self.createdAtLabel = timeLable;
    
    // 星标
    UILabel *starLabel = [IonIcons labelWithIcon:ion_android_star size:16 color:[UIColor colorWithRGBA:0x999999FF]];
    [timeAndCommandsView addSubview:starLabel];
    self.starLabel = starLabel;
    
    // 操作
    UIButton *commandButton = [UIButton new];
    UIImage *commandButtonImage = [IonIcons imageWithIcon:ion_navicon_round iconColor:[UIColor grayColor] iconSize:15 imageSize:CGSizeMake(45.0f, 40.0f)];
    [commandButton setImage:commandButtonImage forState:UIControlStateNormal];
    [timeAndCommandsView addSubview:commandButton];
    self.commandButton = commandButton;
    [commandButton addTarget:self action:@selector(switchCommandsToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeConstraintsWithReuseIdentifier:reuseIdentifier];
        
    return self;
}

- (void)makeConstraintsWithReuseIdentifier:(NSString *)reuseIdentifier
{
    // 约束
    [self.userAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userAvatarImageView.mas_right).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.height.equalTo(@18);
    }];
    
    [self.teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userButton);
        make.top.equalTo(self.userButton.mas_bottom).with.offset(5);
        make.height.equalTo(@14);
    }];
    
    [self.feedContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teamButton.mas_bottom);
        make.left.equalTo(self.userButton);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]) {
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.feedContentView);
            make.top.equalTo(self.feedContentView).with.offset(6);
        }];
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        [self.punchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userButton.mas_right).offset(5);
            make.top.equalTo(self.userButton);
        }];
    } else if ([reuseIdentifier isEqualToString:imageCellReuseIdentifier]) {
        [self.feedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.feedContentView);
            make.top.equalTo(self.feedContentView).offset(10);
        }];
    } else if ([reuseIdentifier isEqualToString:shareCellReuseIdentifier]) {
        [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.feedContentView);
            make.top.equalTo(self.feedContentView).offset(10);
        }];
        
        [self.shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.shareView).insets(UIEdgeInsetsMake(5, 8, 5, 8));
        }];
    }
    
    [self.timeAndCommandsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedContentView.mas_bottom).priorityHigh();
        make.left.equalTo(self.userButton);
        make.right.bottom.equalTo(self.contentView);
    }];
    
    [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.timeAndCommandsView);
    }];
    
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeAndCommandsView);
        make.left.equalTo(self.createdAtLabel.mas_right).offset(15);
    }];
    
    [self.commandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.timeAndCommandsView);
    }];
}

/**
 *  获取某feed对应的resuseIdentifier
 *
 *  @param feed <#feed description#>
 *
 *  @return <#return value description#>
 */
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

/**
 *  计算单元格高度
 *
 *  @param feed <#feed description#>
 *
 *  @return 单元格高度
 */
+ (CGFloat)calculateCellHeightWithFeed:(TMFeed *)feed
{
    FeedTableViewCell *sizingCell;
    static FeedTableViewCell *imageCell;
    static FeedTableViewCell *punchCell;
    static FeedTableViewCell *textCell;
    static FeedTableViewCell *shareCell;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellReuseIdentifier];
        punchCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:punchCellReuseIdentifier];
        textCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellReuseIdentifier];
        shareCell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareCellReuseIdentifier];
    });
    
    NSString *reuseIdentifier = [self getResuseIdentifierByFeed:feed];
    
    if ([reuseIdentifier isEqualToString:imageCellReuseIdentifier]) {
        sizingCell = imageCell;
    } else if ([reuseIdentifier isEqualToString:punchCellReuseIdentifier]) {
        sizingCell = punchCell;
    } else if ([reuseIdentifier isEqualToString:textCellReuseIdentifier]){
        sizingCell = textCell;
    } else {
        sizingCell = shareCell;
    }
    
    [sizingCell updateCellWithFeed:feed];
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

/**
 *  设置UILable的preferredMaxLayoutWidth
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.myTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.myTextLabel.frame);
    self.shareTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.shareTitleLabel.frame);
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
    [self.userAvatarImageView setImageWithURL:[NSURL URLWithString:feed.user.avatar]];
    self.userAvatarImageView.tag = feed.userIdValue;
    
    // 时间
    self.createdAtLabel.text = [feed.createdAt friendlyInterval];
    
    // 星标
    self.starLabel.hidden = !feed.starred;
    
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
    } else if ([reuseIdentifier isEqualToString:shareCellReuseIdentifier]) {
        self.shareView.tag = feed.idValue;
        self.shareTitleLabel.text = feed.shareTitle;
    }
}

/**
 *  用户按钮点击事件
 *
 *  @param sender <#sender description#>
 */
- (void)userButtonClicked:(UIButton *)sender
{
    [self.delegate redirectToUserProfile:[NSNumber numberWithLong:sender.tag]];
}

/**
 *  用户头像点击事件
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
- (void)userAvatarClicked:(UITapGestureRecognizer *)gestureRecognizer
{
    [self hideCommandsToolbar];
    [self.delegate redirectToUserProfile:[NSNumber numberWithLong:gestureRecognizer.view.tag]];
}

/**
 *  分享view点击事件
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
- (void)shareViewClicked:(UITapGestureRecognizer *)gestureRecognizer
{
    gestureRecognizer.view.backgroundColor = [UIColor colorWithRGBA:0xDDDDDDFF];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate redirectToExternalLinkView:[NSNumber numberWithLong:gestureRecognizer.view.tag]];
        gestureRecognizer.view.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    });
}

/**
 *  feed图片点击事件
 */
- (void)imageViewTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor blackColor];
    self.feedImagePreviewBackdropView = backgroundView;
    [window addSubview:backgroundView];
    UITapGestureRecognizer *gestureForBackgroundView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedImagePreviewBackdropViewTapped:)];
    gestureForBackgroundView.numberOfTapsRequired = 1;
    [backgroundView addGestureRecognizer:gestureForBackgroundView];
    
    UIImageView *oldImageView = (UIImageView *)gestureRecognizer.view;
    UIImage *image = oldImageView.image;
    CGRect oldFrame = [oldImageView.superview convertRect:oldImageView.frame toView:window];
    self.feedImagePreviewImageViewOriginalFrame = oldFrame;
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:image];
    self.feedImagePreviewImageView = newImageView;
    newImageView.frame = oldFrame;
    [backgroundView addSubview:newImageView];
    
    // 约束
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [window setNeedsLayout];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect newFrame;
        newFrame.size.width = MIN(window.frame.size.width, image.size.width);
        newFrame.size.height = MIN(window.frame.size.height, image.size.height);
        newFrame.origin.x = (window.frame.size.width - newFrame.size.width) / 2.0;
        newFrame.origin.y = (window.frame.size.height - newFrame.size.height) / 2.0;
        newImageView.frame = newFrame;
    }];
}

/**
 *  点击backdropView后消失
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
- (void)feedImagePreviewBackdropViewTapped:(UIGestureRecognizer* )gestureRecognizer
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    });
    
    [UIView animateWithDuration:.3 animations:^{
        self.feedImagePreviewBackdropView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.feedImagePreviewImageView.frame = self.feedImagePreviewImageViewOriginalFrame;
    } completion:^(BOOL finished) {
        [self.feedImagePreviewBackdropView removeFromSuperview];
        self.feedImagePreviewBackdropView = nil;
        self.feedImagePreviewImageView = nil;
    }];
}

// 重置布局
- (void)resetLayout
{
    [self hideCommandsToolbar];
}

#pragma mark - commands toolbar

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

- (UIView *)commandsToolbar
{
    if (!_commandsToolbar) {
        _commandsToolbar = [UIView new];
        _commandsToolbar.backgroundColor = [UIColor colorWithRGBA:0x333333FF];
        _commandsToolbar.layer.cornerRadius = 2;
        _commandsToolbar.layer.masksToBounds = YES;
        
        // 星标
        UIButton *starButton = [UIButton new];
        [starButton setTitle:ion_android_star forState:UIControlStateNormal];
        [starButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        starButton.titleLabel.font = [IonIcons fontWithSize:16];
        [starButton addTarget:self action:@selector(starFeed) forControlEvents:UIControlEventTouchUpInside];
        [_commandsToolbar addSubview:starButton];
        
        // 分隔符
        UIView *firstDivider = [UIView new];
        firstDivider.backgroundColor = [UIColor colorWithRGBA:0x555555FF];
        [_commandsToolbar addSubview:firstDivider];
        
        // 赞
        UIButton *likeButton = [UIButton new];
        [likeButton setTitle:ion_ios_heart forState:UIControlStateNormal];
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        likeButton.titleLabel.font = [IonIcons fontWithSize:14];
        [likeButton addTarget:self action:@selector(likeFeed) forControlEvents:UIControlEventTouchUpInside];
        [_commandsToolbar addSubview:likeButton];
        
        // 分隔符
        UIView *secondDivider = [UIView new];
        secondDivider.backgroundColor = [UIColor colorWithRGBA:0x555555FF];
        [_commandsToolbar addSubview:secondDivider];
        
        // 评论
        UIButton *commentButton = [UIButton new];
        [commentButton setTitle:ion_ios_chatbubble forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [IonIcons fontWithSize:16];
        [commentButton addTarget:self action:@selector(commentFeed) forControlEvents:UIControlEventTouchUpInside];
        [_commandsToolbar addSubview:commentButton];
        
        // 约束
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.bottom.equalTo(_commandsToolbar);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
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
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMFeed *feedInContext = [self.feed MR_inContext:localContext];
        feedInContext.starredValue = !feedInContext.starredValue;
    } completion:^(BOOL contextDidSave, NSError *error) {
        self.starLabel.hidden = !self.starLabel.hidden;
        //    [self.delegate starFeed:self.feed];
        [self hideCommandsToolbar];
    }];
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



@end
