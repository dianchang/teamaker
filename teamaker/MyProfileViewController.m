//
//  MyProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/21.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "MyProfileViewController.h"
#import "TMUser.h"
#import "TMTeam.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import <MagicalRecord/MagicalRecord.h>
#import "TeamProfileViewController.h"

@interface MyProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TMUser *loggedInUser;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *teams;

@end

@implementation MyProfileViewController

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser getLoggedInUser];
    }
    
    return _loggedInUser;
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [self.loggedInUser.teams allObjects];
    }
    
    return _teams;
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
    self.view.backgroundColor = [UIColor grayColor];
    
    // 表格
    UITableView *tableView = [UITableView new];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIView *headerView = [UIView new];
    
    // 头像
    UIImageView *avatarView = [UIImageView new];
    [avatarView setImageWithURL:[NSURL URLWithString:self.loggedInUser.avatar]];
    avatarView.layer.cornerRadius = 30;
    avatarView.layer.masksToBounds = YES;
    [headerView addSubview:avatarView];
    
    // 用户名
    UILabel *userLable = [UILabel new];
    userLable.text = self.loggedInUser.name;
    userLable.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:userLable];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.width.equalTo(@60);
        make.height.equalTo(@60).priorityHigh();
        make.top.equalTo(headerView).offset(20);
    }];
    
    [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(avatarView.mas_bottom).offset(10);
        make.bottom.equalTo(headerView).offset(-30);
    }];
    
    [tableView setTableHeaderView:headerView];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.teams.count;
    } else if (section == 1) {
        return 2;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    // 团队
    if (indexPath.section == 0) {
        TMTeam *team = self.teams[indexPath.row];
        cell.textLabel.text = team.name;
    } else if (indexPath.section == 1) {    // 其他
        if (indexPath.row == 0) {
            cell.textLabel.text = @"个人资料";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"设置";
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TMTeam *team = self.teams[indexPath.row];
        
        UIViewController *controller = [[TeamProfileViewController alloc] initWithTeamId:team.id];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
