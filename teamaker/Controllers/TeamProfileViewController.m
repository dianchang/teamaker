//
//  TeamProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/25.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TeamProfileViewController.h"
#import "TMTeam.h"
#import "TMFeed.h"
#import <MagicalRecord/MagicalRecord.h>
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import "FeedTableViewCellProtocol.h"
#import "FeedTableViewCell.h"
#import "UserProfileViewController.h"
#import "TeamProfileViewController.h"
#import "TeamDetailsViewController.h"
#import "ExternalLinkViewController.h"
#import "Constants.h"

@interface TeamProfileViewController ()

@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;

@end

@implementation TeamProfileViewController

- (instancetype)initWithTeamId:(NSNumber *)teamId
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.teamId = teamId;
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // team详细页
    UIBarButtonItem *myProfileButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(redirectToTeamDetails)];
    self.navigationItem.rightBarButtonItem = myProfileButtonItem;
    
    // 添加头
    [self.tableView setTableHeaderView:[self createHeaderView]];
}

- (UIView *)createHeaderView
{
    UIView *headerView = [UIView new];
    
    // 头像
    UIImageView *avatarView = [UIImageView new];
    [avatarView setImageWithURL:[NSURL URLWithString:self.team.avatar]];
    avatarView.layer.cornerRadius = 4;
    avatarView.layer.masksToBounds = YES;
    [headerView addSubview:avatarView];
    
    // 用户名
    UILabel *userLable = [UILabel new];
    userLable.text = self.team.name;
    userLable.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:userLable];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.width.equalTo(@60);
        make.height.equalTo(@60).priorityHigh();
        make.top.equalTo(headerView).offset(20).priorityHigh();
    }];
    
    [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(avatarView.mas_bottom).offset(10);
        make.bottom.equalTo(headerView).offset(-30);
    }];
    
    return headerView;
}

- (void)redirectToTeamDetails
{
    UIViewController *controller = [[TeamDetailsViewController alloc] initWithTeamId:self.teamId];
    [self.navigationController pushViewController:controller animated:YES];
    self.navigationItem.title = self.team.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.team.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
}

- (void)viewDidLayoutSubviews
{
    UIView *headerView = self.tableView.tableHeaderView;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect frame = headerView.frame;
    frame.size.height = size.height;
    headerView.frame = frame;
    [self.tableView setTableHeaderView:headerView];
}

#pragma mark - FeedTableViewCellProtocol

- (void)redirectToExternalLinkView:(NSNumber *)feedId
{
    TMFeed *feed = [TMFeed MR_findFirstByAttribute:@"id" withValue:feedId];
    ExternalLinkViewController *controller = [[ExternalLinkViewController alloc] initWithURL:feed.shareUrl feedCreationCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedViewShouldReloadDataNotification object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

# pragma mark - getters and setters

- (NSMutableArray *)feeds
{
    NSMutableArray *feeds = [super feeds];
    
    if (!feeds) {
        self.feeds = [[TMFeed findByTeamId:self.teamId] mutableCopy];
    }

    return [super feeds];
}

- (TMTeam *)team
{
    if(!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

@end
