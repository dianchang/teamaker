//
//  FeedTableViewCellProtocol.h
//  teamaker
//
//  Created by hustlzp on 15/8/23.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMFeed.h"
#import <UIKit/UIKit.h>

@protocol FeedTableViewCellProtocol <NSObject>

// 跳转到用户主页
- (void)redirectToUserProfile:(NSNumber *)userId;

// 跳转到团队主页
- (void)redirectToTeamProfile:(NSNumber *)teamId;

// 跳转到分享网页
- (void)redirectToExternalLinkView:(NSNumber *)feedId;

// 打星标
- (void)starFeed:(TMFeed *)feed;

// 赞
- (void)likeFeed:(TMFeed *)feed;

// 评论
- (void)commentFeed:(TMFeed *)feed sender:(UITableViewCell *)cell;

@end
