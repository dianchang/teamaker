//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "AFNetworking.h"
#import "IonIcons.h"
#import "TMFeed.h"
#import "MyProfileViewController.h"
#import "UIColor+Helper.h"
#import "UIImageView+AFNetworking.h"
#import "FeedTableViewCell.h"
#import "UserProfileViewController.h"
#import "TeamProfileViewController.h"
#import "Constants.h"
#import "ExternalLinkViewController.h"
#import "BaseFeedViewController.h"

@interface BaseFeedViewController ()
@end

@implementation BaseFeedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    // 表格
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    UITableView *tableView = [[UITableView alloc] init];
    tableViewController.view = tableView;
    [self addChildViewController:tableViewController];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.allowsSelection = NO;
    tableView.separatorColor = [UIColor TMBackgroundColorGray];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 注册reuseIdentifier
    [FeedTableViewCell registerClassForCellReuseIdentifierOnTableView:tableView];
    
    // 约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - FeedTableViewCellProtocol

// 跳转用户主页
- (void)redirectToUserProfile:(NSNumber *)userId
{
    UserProfileViewController *controller = [[UserProfileViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:controller animated:YES];
}

// 跳转团队主页
- (void)redirectToTeamProfile:(NSNumber *)teamId
{
    TeamProfileViewController *controller = [[TeamProfileViewController alloc] initWithTeamId:teamId];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)redirectToExternalLinkView:(NSNumber *)feedId
{
    // 需重载
}

// 星标feed
- (void)starFeed:(TMFeed *)feed
{
}

// 赞feed
- (void)likeFeed:(TMFeed *)feed
{
}

// 评论feed
- (void)commentFeed:(TMFeed *)feed
{
}

# pragma mark - tableview dataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feeds.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        TMFeed *feed = self.feeds[indexPath.row / 2];
        NSString *cellIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
        FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.delegate = self;
        [cell updateCellWithFeed:feed];
        
        return cell;
    } else {
        UITableViewCell *cell = [UITableViewCell new];
        
        UIView *gapView = [UIView new];
        gapView.backgroundColor = [UIColor TMBackgroundColorGray];
        
        UIView *topBorderView = [UIView new];
        topBorderView.backgroundColor = [UIColor colorWithRGBA:0xD8D8D8FF];
        [gapView addSubview:topBorderView];
                                   
        [cell.contentView addSubview:gapView];
        
        [gapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        [topBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(gapView);
            make.height.equalTo(@0.5);
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if (indexPath.row % 2 == 0) {
        static NSMutableDictionary *cachedHeight;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cachedHeight = [NSMutableDictionary new];
        });
        
        TMFeed *feed = self.feeds[indexPath.row / 2];
        NSNumber *cellHeight = [cachedHeight objectForKey:[feed.id stringValue]];
        
        if (cellHeight) {
            return [cellHeight floatValue];
        }
        
        height = [FeedTableViewCell calculateCellHeightWithFeed:feed];
        height += 1.0;
        
        [cachedHeight setObject:[NSNumber numberWithFloat:height] forKey:[feed.id stringValue]];
    } else if (indexPath.row == self.feeds.count * 2 - 1) {
        height = 40.0;
    } else {
        height = 15.0;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    
    if (indexPath.row % 2 == 0) {
        TMFeed *feed = self.feeds[indexPath.row / 2];
        
        if ([feed.kind isEqualToString:@"punch"]) {
            cellHeight = 90.0;
        } else if ([feed.kind isEqualToString:@"image"]) {
            cellHeight = 280.0;
        } else if ([feed.kind isEqualToString:@"text"]) {
            cellHeight = 150.0;
        } else if ([feed.kind isEqualToString:@"share"]) {
            cellHeight = 150.0;
        }
    } else if (indexPath.row == self.feeds.count * 2 - 1) {
        cellHeight = 40.0;
    } else {
        cellHeight = 15.0;
    }
    
    return cellHeight;
}

#pragma mark - getters and setters

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser getLoggedInUser];
    }
    
    return _loggedInUser;
}

@end
