//
//  FeedTableViewCell.h
//  teamaker
//
//  Created by hustlzp on 15/8/22.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMFeed.h"
#import "FeedTableViewCellProtocol.h"
#import "LikersView.h"
#import "FeedCommentsView.h"

@interface FeedTableViewCell : UITableViewCell

@property (weak, nonatomic) id<FeedTableViewCellProtocol> delegate;
@property (strong, nonatomic) TMFeed *feed;

@property (strong, nonatomic) UIImageView *userAvatarImageView;
@property (strong, nonatomic) UIButton *userButton;
@property (strong, nonatomic) UIButton *teamButton;

@property (strong, nonatomic) UIView *feedContentView;

@property (strong, nonatomic) UIView *timeAndCommandsView;
@property (strong, nonatomic) UILabel *createdAtLabel;
@property (strong, nonatomic) UILabel *deleteButton;
@property (strong, nonatomic) UILabel *starLabel;
@property (strong, nonatomic) UIButton *commandButton;
@property (strong, nonatomic) UIView *commandsToolbar;

@property (strong, nonatomic) UIView *likersTopGapView;
@property (strong, nonatomic) LikersView *likersView;
@property (strong, nonatomic) UIView *likersCommentsGapView;

@property (strong, nonatomic) FeedCommentsView *commentsView;
@property (strong, nonatomic) UIView *commentsBottomGapView;

+ (NSString *)getResuseIdentifierByFeed:(TMFeed *)feed;
+ (void)registerClassForCellReuseIdentifierOnTableView:(UITableView *)tableView;
+ (CGFloat)calculateCellHeightWithFeed:(TMFeed *)feed tableViewWidth:(CGFloat)tableViewWidth;
- (void)updateCellWithFeed:(TMFeed *)feed;

@end
