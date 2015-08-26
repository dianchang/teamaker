//
//  TeamProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/25.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TeamProfileViewController.h"
#import "TMTeam.h"
#import <MagicalRecord/MagicalRecord.h>
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import "FeedTableViewCellProtocol.h"
#import "FeedTableViewCell.h"
#import "UserProfileViewController.h"
#import "TeamProfileViewController.h"
#import "TeamDetailsViewController.h"

@interface TeamProfileViewController () <UITableViewDataSource, UITableViewDelegate, FeedTableViewCellProtocol>

@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *feeds;

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
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *myProfileButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(redirectToTeamDetails)];
    self.navigationItem.rightBarButtonItem = myProfileButtonItem;
    
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setTableHeaderView:[self createHeaderView]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 注册reuseIdentifier
    [FeedTableViewCell registerClassForCellReuseIdentifierOnTableView:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIView *)createHeaderView
{
    UIView *headerView = [UIView new];
    
    // 头像
    UIImageView *avatarView = [UIImageView new];
    [avatarView setImageWithURL:[NSURL URLWithString:self.team.avatar]];
    avatarView.layer.cornerRadius = 30;
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

- (TMTeam *)team
{
    if(!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

- (NSArray *)feeds
{
    if (!_feeds) {
        _feeds = [self.team.feeds allObjects];
    }
    
    return _feeds;
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

# pragma mark - tableview datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMFeed *feed = self.feeds[indexPath.row];
    NSString *cellIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    [cell updateCellWithFeed:feed];
    return cell;
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMFeed *feed = self.feeds[indexPath.row];
    NSString *cellIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
    FeedTableViewCell *sizingCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [sizingCell updateCellWithFeed:feed];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f;
}

@end
