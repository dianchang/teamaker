//
//  UserProfileViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/25.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TMUser.h"
#import "TMTeam.h"
#import "TMTeamUserInfo.h"
#import "Masonry.h"
#import "UIColor+Helper.h"
#import "UIImageView+AFNetworking.h"
#import "Constants.h"
#import <MagicalRecord/MagicalRecord.h>
#import "TeamProfileViewController.h"

@interface UserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSNumber *userId;
@property (strong, nonatomic) TMUser *user;
@property (strong, nonatomic) NSArray *teamInfos;
@property (strong, nonatomic) UITableView *tableView;
 
@end

@implementation UserProfileViewController

- (instancetype)initWithUserId:(NSNumber *)userId
{
    self = [super init];
    
    if (self) {
        self.userId = userId;
    }

    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [tableView setTableHeaderView:[self createHeaderView]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.user.name;
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
    [avatarView setImageWithURL:[NSURL URLWithString:self.user.avatar]];
    avatarView.layer.cornerRadius = 30;
    avatarView.layer.masksToBounds = YES;
    [headerView addSubview:avatarView];
    
    // 用户名
    UILabel *userLable = [UILabel new];
    userLable.text = self.user.name;
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


# pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return self.teamInfos.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configTextCell:cell key:@"地区" value:self.user.province];
        } else if (indexPath.row == 1) {
            [self configTextCell:cell key:@"个性签名" value:self.user.motto];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configTextCell:cell key:@"手机号" value:self.user.phone];
        } else if (indexPath.row == 1) {
            [self configTextCell:cell key:@"邮箱" value:self.user.email];
        } else if (indexPath.row == 2) {
            [self configTextCell:cell key:@"微信" value:self.user.wechat];
        }
    } else if (indexPath.section == 2) {
        TMTeamUserInfo *teamInfo = self.teamInfos[indexPath.row];
        [self configTeamCell:cell teamUserInfo:teamInfo];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 45;
    } else if (indexPath.section == 2) {
        return 60;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else if (section == 1 || section == 2) {
        return 15;
    } else if (section == 3) {
        return 80;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)configTextCell:(UITableViewCell *)cell key:(NSString *)key value:(NSString *)value
{
    UILabel *keyLabel = [UILabel new];
    keyLabel.text = key;
    keyLabel.textColor = [UIColor grayColor];
    keyLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:keyLabel];
    
    UILabel *valueLabel = [UILabel new];
    valueLabel.text = value;
    valueLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:valueLabel];
    
    // 约束
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
        make.width.equalTo(@80);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(keyLabel.mas_right);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 2) {
        return;
    }
    
    TMTeamUserInfo *info = self.teamInfos[indexPath.row];
    
    UIViewController *controller = [[TeamProfileViewController alloc] initWithTeamId:info.teamId];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)configTeamCell:(UITableViewCell *)cell teamUserInfo:(TMTeamUserInfo *)teamUserInfo
{
    // 图像
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [imageView setImageWithURL:[NSURL URLWithString:teamUserInfo.team.avatar]];
    [cell.contentView addSubview:imageView];
    
    // 团队
    UILabel *teamLabel = [UILabel new];
    teamLabel.font = [UIFont boldSystemFontOfSize:14];
    teamLabel.text = teamUserInfo.team.name;
    [cell.contentView addSubview:teamLabel];
    
    // 我在该团队的简介
    UILabel *descLabel = [UILabel new];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    descLabel.text = teamUserInfo.desc;
    [cell.contentView addSubview:descLabel];
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    if (teamUserInfo.desc) {
        [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.top.equalTo(cell.contentView).offset(12);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(teamLabel);
            make.top.equalTo(teamLabel.mas_bottom).offset(10);
        }];
    } else {
        [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(cell.contentView);
        }];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

# pragma mark - getters and setters

- (TMUser *)user
{
    if (!_user) {
        _user = [TMUser MR_findFirstByAttribute:@"id" withValue:self.userId];
    }
    
    return _user;
}

- (NSArray *)teamInfos
{
    if (!_teamInfos) {
        _teamInfos = [self.user.teamsInfos allObjects];
    }
    
    return _teamInfos;
}

@end
