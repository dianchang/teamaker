//
//  AddTeamMemberViewController.m
//  teamaker
//
//  Created by hustlzp on 15/9/7.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "AddTeamMemberViewController.h"
#import "Masonry.h"
#import "TMTeam.h"
#import "TMUser.h"
#import <MagicalRecord/MagicalRecord.h>
#import "UIImageView+AFNetworking.h"
#import "TMTeamUserInfo.h"
#import "UIColor+Helper.h"

@interface AddTeamMemberViewController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) TMUser *loggedInUser;
@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;
@property (strong, nonatomic) NSArray *teamUserInfos;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AddTeamMemberViewController

- (instancetype)initWithTeamId:(NSNumber *)teamId
{
    self = [super init];
    if (self) {
        self.teamId = teamId;
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 完成按钮
    UIBarButtonItem *continueButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAddingTeamMember)];
    self.navigationItem.rightBarButtonItem = continueButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

# pragma mark - tableview delegate

//static NSString * const cellIdentifier = @"identifier";

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 + self.teamUserInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configStaticTableViewCell:cell imageUrl:@"http://www.1jingdian.com/uploads/collectionCovers/default.png" key:@"通过微信" value:nil];
        } else if (indexPath.row == 1) {
            [self configStaticTableViewCell:cell imageUrl:@"http://www.1jingdian.com/uploads/collectionCovers/default.png" key:@"通过手机联系人" value:@"已添加 1 人"];
        } else if (indexPath.row == 2) {
            [self configStaticTableViewCell:cell imageUrl:@"http://www.1jingdian.com/uploads/collectionCovers/default.png" key:@"通过工作邮箱" value:@"已添加 2 人"];
        }
    } else if (indexPath.section == 1) {
        TMTeamUserInfo *userInfo = self.teamUserInfos[indexPath.row];
        [self configMemberTableViewCell:cell userInfo:userInfo];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60.0;
    } else {
        return 60.0;
    }
}

/**
 *  配置静态cell
 *
 *  @param cell  <#cell description#>
 *  @param url   <#url description#>
 *  @param key   <#key description#>
 *  @param value <#value description#>
 */
- (void)configStaticTableViewCell:(UITableViewCell *)cell imageUrl:(NSString *)url key:(NSString *)key value:(NSString *)value
{
    UIImageView *imageView = [UIImageView new];
    [imageView setImageWithURL:[NSURL URLWithString:url]];
    imageView.layer.cornerRadius = 2;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *keyLabel = [UILabel new];
    keyLabel.text = key;
    keyLabel.textColor = [UIColor grayColor];
    keyLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:keyLabel];
    
    UILabel *valueLable;
    
    if (value) {
        valueLable = [UILabel new];
        valueLable.text = value;
        [cell.contentView addSubview:valueLable];
    }
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(imageView.mas_right).offset(15);
    }];
    
    [valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(cell.contentView);
    }];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

/**
 *  配置用户cell
 *
 *  @param cell     <#cell description#>
 *  @param userInfo <#userInfo description#>
 */
- (void)configMemberTableViewCell:(UITableViewCell *)cell userInfo:(TMTeamUserInfo *)userInfo
{
    UIImageView *imageView = [UIImageView new];
    [imageView setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    imageView.layer.cornerRadius = 25;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = userInfo.name;
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:nameLabel];
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(imageView.mas_right).offset(15);
    }];
}

# pragma mark - private methods

- (void)finishAddingTeamMember
{
}

# pragma mark - getters and setters

- (TMTeam *)team
{
    if (!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser getLoggedInUser];
    }
    
    return _loggedInUser;
}

- (NSArray *)teamUserInfos
{
    if (!_teamUserInfos) {
        _teamUserInfos = [TMTeamUserInfo MR_findByAttribute:@"teamId" withValue:self.teamId andOrderBy:@"createdAt" ascending:NO];
    }
    
    return _teamUserInfos;
}

@end
