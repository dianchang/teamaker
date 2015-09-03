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

@interface FeedTableViewCell : UITableViewCell

@property (strong, nonatomic) id<FeedTableViewCellProtocol> delegate;
@property (strong, nonatomic) UIImageView *userAvatarImageView;
@property (strong, nonatomic) UIButton *userButton;
@property (strong, nonatomic) UIButton *teamButton;
@property (strong, nonatomic) UILabel *createdAtLabel;
@property (strong, nonatomic) UILabel *myTextLabel;
@property (strong, nonatomic) UILabel *punchLabel;
@property (strong, nonatomic) UIImageView *feedImageView;

+ (NSString *)getResuseIdentifierByFeed:(TMFeed *)feed;
+ (void)registerClassForCellReuseIdentifierOnTableView:(UITableView *)tableView;
- (void)updateCellWithFeed:(TMFeed *)feed;

@end
