//
//  TeamDetailsViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/26.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TeamDetailsViewController.h"
#import "TMTeam.h"
#import "TMFeed.h"
#import "TMTeamUserInfo.h"
#import "TMUser.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import "TeamMemberCollectionViewCell.h"
#import "UIColor+Helper.h"

@interface TeamDetailsViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;
@property (strong, nonatomic) NSArray *userInfos;
@property (strong, nonatomic) NSArray *starFeeds;
@property (strong, nonatomic) TMUser *loggedInUser;
@property (strong, nonatomic) TMTeamUserInfo *teamUserInfo;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation TeamDetailsViewController

static NSString* collectionViewReuseIdentifier = @"CollectionViewCellIdentifier";

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    [tableView setTableHeaderView:[self createHeaderView]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView setTableHeaderView:[self createHeaderView]];
    [self.tableView setTableFooterView:[self createFooterView]];

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIView *)createHeaderView
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    // 头像
    UIImageView *avatarView = [UIImageView new];
    [avatarView setImageWithURL:[NSURL URLWithString:self.team.avatar]];
    avatarView.layer.cornerRadius = 4;
    avatarView.layer.masksToBounds = YES;
    [headerView addSubview:avatarView];
    
    // 团队名
    UILabel *userLable = [UILabel new];
    userLable.text = self.team.name;
    userLable.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:userLable];
    
    // 成员
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[UICollectionViewFlowLayout new]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [collectionView registerClass:[TeamMemberCollectionViewCell class] forCellWithReuseIdentifier:collectionViewReuseIdentifier];
    [headerView addSubview:collectionView];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.top.equalTo(headerView).offset(20).priorityHigh();
    }];
    
    [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(avatarView.mas_bottom).offset(8);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView).offset(-15);
        make.top.equalTo(userLable.mas_bottom).offset(20);
    }];
    
    return headerView;
}

- (UIView *)createFooterView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor TMBackgroundColorGray];
    
    // 退出圈子
    UIButton *quitButton = [UIButton new];
    [quitButton setTitle:@"退出圈子" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    quitButton.backgroundColor = [UIColor colorWithRGBA:0x666666FF];
    quitButton.layer.cornerRadius = 2;
    quitButton.layer.masksToBounds = YES;
    [footerView addSubview:quitButton];
    
    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(15, 10, 15, 10)).priorityHigh();
    }];
    
    return footerView;
}

- (void)viewDidLayoutSubviews
{
    [self sizeHeaderViewToFit];
    [self sizeFooterViewToFit];
}

- (void)sizeHeaderViewToFit
{
    UIView *headerView = self.tableView.tableHeaderView;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect frame = headerView.frame;
    frame.size.height = size.height + self.collectionView.contentSize.height;
    headerView.frame = frame;
    [self.tableView setTableHeaderView:headerView];
}

- (void)sizeFooterViewToFit
{
    UIView *footerView = self.tableView.tableFooterView;
    [footerView setNeedsLayout];
    [footerView layoutIfNeeded];
    CGSize size = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect frame = footerView.frame;
    frame.size.height = size.height;
    footerView.frame = frame;
    [self.tableView setTableFooterView:footerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableview data source and delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    switch (indexPath.section) {
        case 0: {
            [self configTableViewCell:cell ForStarFeeds:self.starFeeds];
            break;
        }
            
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [self configTableViewCell:cell key:@"圈子名称" value:self.teamUserInfo.name];
                    break;
                }
                case 1: {
                    [self configTableViewCell:cell key:@"圈子头像" imageUrl:[NSURL URLWithString:self.team.avatar] border:30 radius:2];
                    break;
                }
                case 2: {
                    [self configTableViewCell:cell key:@"圈子二维码" imageUrl:[NSURL URLWithString:self.team.avatar] border:20 radius:2];
                    break;
                }
                default:
                    break;
            }
            break;
        }

        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [self configTableViewCell:cell key:@"我在该圈子的头像" imageUrl:[NSURL URLWithString:self.loggedInUser.avatar] border:30 radius:15];
                    break;
                }
                case 1: {
                    [self configTableViewCell:cell key:@"我在该圈子的昵称" value:@"哈丁"];
                    break;
                }
                case 2: {
                    [self configTableViewCell:cell key:@"我在该圈子的简介" value:@"产品经理"];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default:
            return nil;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)configTableViewCell:(UITableViewCell *)cell ForStarFeeds:(NSArray *)starFeeds
{
    if (starFeeds.count == 0) {
    }
    
    UIView *firstStarFeedView = [UIView new];
    firstStarFeedView.backgroundColor = [UIColor colorWithRGBA:0xBBBBBBFFF];
    [cell.contentView addSubview:firstStarFeedView];
    
    UIView *secondStarFeedView = [UIView new];
    secondStarFeedView.backgroundColor = [UIColor colorWithRGBA:0xBBBBBBFFF];
    [cell.contentView addSubview:secondStarFeedView];
    
    [firstStarFeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.width.equalTo(secondStarFeedView);
        make.right.equalTo(secondStarFeedView.mas_left).offset(-10);
        make.centerY.equalTo(cell.contentView);
        make.height.equalTo(@50);
    }];
    
    [secondStarFeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView);
        make.centerY.equalTo(cell.contentView);
        make.height.equalTo(@50);
    }];
}

- (void)configTableViewCell:(UITableViewCell *)cell key:(NSString *)key value:(NSString *)value
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
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView);
    }];
}

- (void)configTableViewCell:(UITableViewCell *)cell key:(NSString *)key imageUrl:(NSURL *)imageUrl border:(NSInteger)border radius:(NSInteger)radius
{
    UILabel *keyLabel = [UILabel new];
    keyLabel.text = key;
    keyLabel.textColor = [UIColor grayColor];
    keyLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:keyLabel];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImageWithURL:imageUrl];
    imageView.layer.cornerRadius = radius;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    // 约束
    [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(15);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo([NSNumber numberWithInteger:border]);
        make.height.equalTo([NSNumber numberWithInteger:border]);
        make.right.equalTo(cell.contentView);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    
    if (section == 0) {
        UILabel *myLabel = [UILabel new];
        myLabel.font = [UIFont boldSystemFontOfSize:12];
        myLabel.textColor = [UIColor colorWithRGBA:0xAAAAAAFF];
        myLabel.text = @"★ 星标内容";
        [headerView addSubview:myLabel];
        
        [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(15);
            make.bottom.equalTo(headerView).offset(-8);
        }];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    } else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 3;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - collection view delegate and data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMTeamUserInfo *userInfo = self.userInfos[indexPath.row];
    
    TeamMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewReuseIdentifier forIndexPath:indexPath];
    [cell updateDataWithUser:userInfo.user];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userInfos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static TeamMemberCollectionViewCell *sizingCell;
    static dispatch_once_t onceToken;
    TMTeamUserInfo *userInfo = self.userInfos[indexPath.row];
    
    dispatch_once(&onceToken, ^{
        sizingCell = [[TeamMemberCollectionViewCell alloc] initWithFrame:CGRectZero];
    });
    
    [sizingCell updateDataWithUser:userInfo.user];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width = 100;
    size.height += 10;

    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - getters and setters

- (TMTeam *)team
{
    if (!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

- (NSArray *)userInfos
{
    if (!_userInfos) {
        _userInfos = [self.team.usersInfos allObjects];
    }
    
    return _userInfos;
}

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser getLoggedInUser];
    }
    
    return _loggedInUser;
}

- (TMTeamUserInfo *)teamUserInfo
{
    if (!_teamUserInfo) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId == %@) AND (teamId == %@)", self.loggedInUser.id, self.teamId];
        _teamUserInfo = [TMTeamUserInfo MR_findFirstWithPredicate:predicate];
    }
    
    return _teamUserInfo;
}

- (NSArray *)starFeeds
{
    if (!_starFeeds) {
        _starFeeds = [self.team.feeds allObjects];
    }
    
    return _starFeeds;
}

@end
