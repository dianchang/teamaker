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
#import "TMTeamUserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import <MagicalRecord/MagicalRecord.h>
#import "TeamProfileViewController.h"
#import "MyDetailsViewController.h"
#import "MySettingsViewController.h"
#import "UIColor+Helper.h"

@interface MyProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) TMUser *loggedInUser;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *teamInfos;

@end

@implementation MyProfileViewController

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
    self.view.backgroundColor = [UIColor grayColor];
    
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [tableView setTableHeaderView:[self createHeaderView]];
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

- (UIView *)createHeaderView
{
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
        make.bottom.equalTo(headerView).offset(-30).priorityHigh();
    }];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.teamInfos.count;
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
        TMTeamUserInfo *teamInfo = self.teamInfos[indexPath.row];
        [self configTeamCell:cell team:teamInfo.team];
    } else if (indexPath.section == 1) {    // 其他
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"个人资料";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"设置";
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)configTeamCell:(UITableViewCell *)cell team:(TMTeam *)team
{
    // 图像
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [imageView setImageWithURL:[NSURL URLWithString:team.avatar]];
    [cell.contentView addSubview:imageView];
    
    // 团队
    UILabel *teamLabel = [UILabel new];
    teamLabel.font = [UIFont boldSystemFontOfSize:14];
    teamLabel.text = team.name;
    [cell.contentView addSubview:teamLabel];
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.centerY.equalTo(cell.contentView);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        TMTeamUserInfo *teamInfo = self.teamInfos[indexPath.row];
        
        UIViewController *controller = [[TeamProfileViewController alloc] initWithTeamId:teamInfo.teamId];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIViewController *controller = [[MyDetailsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 1) {
            UIViewController *controller = [[MySettingsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

# pragma mark - getters and setters

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser findLoggedInUser];
    }
    
    return _loggedInUser;
}

- (NSArray *)teamInfos
{
    if (!_teamInfos) {
        _teamInfos = [self.loggedInUser.teamsInfos allObjects];
    }
    
    return _teamInfos;
}

@end
