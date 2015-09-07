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
@property (strong, nonatomic) NSArray *teammates;
@property (strong, nonatomic) TMTeamUserInfo *myUserInfo;

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
}

# pragma mark - tableview delegate

//static NSString * const cellIdentifier = @"identifier";

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return self.teammates.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configStaticTableViewCell:cell imageUrl:@"http://www.1jingdian.com/uploads/collectionCovers/default.png" key:@"通过微信" value:nil];
        } else if (indexPath.row == 1) {
            [self configStaticTableViewCell:cell imageUrl:@"http://www.1jingdian.com/uploads/collectionCovers/default.png" key:@"通过手机联系人" value:[[NSString alloc] initWithFormat:@"已添加 %d 人", self.myUserInfo.membersCountInvitedViaContactValue]];
        } else if (indexPath.row == 2) {
            [self configStaticTableViewCell:cell imageUrl:@"http://www.1jingdian.com/uploads/collectionCovers/default.png" key:@"通过工作邮箱" value:[[NSString alloc] initWithFormat:@"已添加 %d 人", self.myUserInfo.membersCountInvitedViaEmailValue]];
        }
    } else if (indexPath.section == 1) {
        TMTeamUserInfo *userInfo = self.teammates[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    keyLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:keyLabel];
    
    UILabel *valueLable;
    if (value) {
        valueLable = [UILabel new];
        valueLable.text = value;
        valueLable.font = [UIFont systemFontOfSize:13];
        valueLable.textColor = [UIColor grayColor];
        [cell.contentView addSubview:valueLable];
    }
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(imageView.mas_right).offset(10);
    }];
    
    if (value) {
        [valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(cell.contentView);
        }];
    }
    
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
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = userInfo.name;
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:nameLabel];
    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(imageView.mas_right).offset(10);
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

- (NSArray *)teammates
{
    if (!_teammates) {
        NSMutableArray *myTeamsIdList = [NSMutableArray new];
        NSArray *teammateUserInfos = [NSArray new];
        NSMutableArray *uniqueTeammateUserInfos = [NSMutableArray new];
        
        for (TMTeamUserInfo *teamInfo in self.loggedInUser.teamsInfos) {
            [myTeamsIdList addObject:teamInfo.teamId];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId IN %@) AND (userId != %@)", myTeamsIdList, self.loggedInUser.id];
        teammateUserInfos = [TMTeamUserInfo MR_findAllWithPredicate:predicate];

        NSMutableDictionary *existingUsers = [NSMutableDictionary new];
        for (TMTeamUserInfo *teammateUserInfo in teammateUserInfos) {
            if (![existingUsers objectForKey:[teammateUserInfo.userId stringValue]]) {
                [existingUsers setObject:teammateUserInfo forKey:[teammateUserInfo.userId stringValue]];
                [uniqueTeammateUserInfos addObject:teammateUserInfo];
            }
        }

        _teammates = uniqueTeammateUserInfos;
    }
    
    return _teammates;
}
                                                                                                                                                 
- (TMTeamUserInfo *)myUserInfo
{
    if (_myUserInfo) {
        _myUserInfo = [TMTeamUserInfo findByTeamId:self.teamId userId:self.loggedInUser.id];
    }
    
    return _myUserInfo;
}

@end
