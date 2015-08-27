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
#import "TMUser.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import "TeamMemberCollectionViewCell.h"

@interface TeamDetailsViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;
@property (strong, nonatomic) NSArray *users;
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
    
    UITableView *tableView = [UITableView new];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setTableHeaderView:[self createHeaderView]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView setTableHeaderView:[self createHeaderView]];

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (TMTeam *)team
{
    if (!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

- (NSArray *)users
{
    if (!_users) {
        _users = [self.team.users allObjects];
    }
    
    return _users;
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
        make.top.equalTo(avatarView.mas_bottom).offset(5);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(headerView);
        make.top.equalTo(userLable.mas_bottom).offset(20);
    }];
    
    return headerView;
}

- (void)viewDidLayoutSubviews
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableview data source and delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - collection view delegate and data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMUser *user = self.users[indexPath.row];
    
    TeamMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewReuseIdentifier forIndexPath:indexPath];
    [cell updateDataWithUser:user];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.users.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static TeamMemberCollectionViewCell *sizingCell;
    static dispatch_once_t onceToken;
    TMUser *user = self.users[indexPath.row];
    
    dispatch_once(&onceToken, ^{
        sizingCell = [[TeamMemberCollectionViewCell alloc] initWithFrame:CGRectZero];
    });
    
    [sizingCell updateDataWithUser:user];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width = 100;
    size.height += 10;

    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hehe");
}

@end
