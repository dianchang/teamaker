//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FeedViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "AFNetworking.h"
#import "IonIcons.h"
#import "TMFeed.h"
#import "MyProfileViewController.h"
#import "UIColor+Helper.h"
#import "UIImageView+AFNetworking.h"
#import "FeedTableViewCellProtocol.h"
#import "FeedTableViewCell.h"
#import "UserProfileViewController.h"
#import "TeamProfileViewController.h"
#import "JoinTeamMenu.h"
#import "CreateTeamViewController.h"
#import "JoinTeamViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, FeedTableViewCellProtocol>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) UIView *backdropView;
@property (strong, nonatomic) JoinTeamMenu *joinTeamMenu;

@end

//#define avatarViewTag

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
//    [self.refreshControl beginRefreshing];
    [self loadFeeds];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFeeds) name:@"ReloadFeeds" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self hideJoinTeamMenu];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    // 导航栏
    self.navigationItem.title = @"圈子";
    
    // 左边按钮
    UIImage *personIcon = [IonIcons imageWithIcon:ion_ios_person size:28 color:[UIColor lightGrayColor]];
    UIBarButtonItem *myProfileButtonItem = [[UIBarButtonItem alloc] initWithImage:personIcon style:UIBarButtonItemStylePlain target:self action:@selector(redirectToMyProfile)];
    self.navigationItem.leftBarButtonItem = myProfileButtonItem;
    
    // 右边按钮
    UIImage *plusIcon = [IonIcons imageWithIcon:ion_android_add size:28 color:[UIColor lightGrayColor]];
    UIBarButtonItem *joinTeamButtonItem = [[UIBarButtonItem alloc] initWithImage:plusIcon style:UIBarButtonItemStylePlain target:self action:@selector(switchJoinTeamMenu)];
    self.navigationItem.rightBarButtonItem = joinTeamButtonItem;

    // 表格
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    UITableView *tableView = [[UITableView alloc] init];
    tableViewController.view = tableView;
    [self addChildViewController:tableViewController];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.allowsSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(loadFeeds) forControlEvents:UIControlEventValueChanged];
//    tableViewController.refreshControl = self.refreshControl;

    [tableViewController didMoveToParentViewController:self];
    
    // 注册reuseIdentifier
    [FeedTableViewCell registerClassForCellReuseIdentifierOnTableView:tableView];
    
    // 下翻按钮
    UIButton *pageDown = [[UIButton alloc] init];
    [pageDown setTitle:@"⌵" forState:UIControlStateNormal];
    [pageDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pageDown.backgroundColor = [UIColor grayColor];
    [pageDown addTarget:self action:@selector(pageDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pageDown];
    
    // 约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.bottom.equalTo(pageDown.mas_top);
    }];

    [pageDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

- (NSMutableArray *)feeds
{
    if (!_feeds) {
        _feeds = [[NSMutableArray alloc] init];
    }
    
    return _feeds;
}

// 跳转到我的主页
- (void)redirectToMyProfile
{
    UIViewController *myProfileViewController = [[MyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileViewController animated:YES];
}

// 显示加入队伍菜单
- (void)switchJoinTeamMenu
{
    if (self.backdropView.superview) {
        [self hideJoinTeamMenu];
    } else {
        // 背景
        [self.view addSubview:self.backdropView];
        [self.backdropView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(44);
        }];
        
        [self.joinTeamMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.backdropView);
            make.bottom.equalTo(self.backdropView.mas_top);
        }];
        
        [self.view layoutIfNeeded];
        
        [self.joinTeamMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.backdropView);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
            [self.view layoutIfNeeded];
        }];
    }
}

// 隐藏加入队伍菜单
- (void)hideJoinTeamMenu
{
    if (!self.joinTeamMenu.superview) {
        return;
    }
    
    [self.joinTeamMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.backdropView);
        make.bottom.equalTo(self.backdropView.mas_top);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.backdropView removeFromSuperview];
    }];
}

// 向下翻页
- (void)pageDown:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PageDown" object:self];
}

// 获取feeds
- (void)loadFeeds
{
    self.feeds = (NSMutableArray *)[TMFeed MR_findAllSortedBy:@"createdAt" ascending:NO];
    [self.tableView reloadData];
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

#pragma mark - getters and setters

- (UIView *)backdropView
{
    if (!_backdropView) {
        _backdropView  = [[UIView alloc] initWithFrame:CGRectZero];
        _backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(hideJoinTeamMenu)];
        tapRecognizer.numberOfTapsRequired = 1;
        [_backdropView addGestureRecognizer:tapRecognizer];
    }
    
    return _backdropView;
}

- (JoinTeamMenu *)joinTeamMenu
{
    if (!_joinTeamMenu) {
        _joinTeamMenu = [[JoinTeamMenu alloc] initWithCreateTeam:^{
            UIViewController *controller = [[CreateTeamViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } joinTeam:^{
            UIViewController *controller = [[JoinTeamViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } inviteFriend:^{
        }];
        
        [self.backdropView addSubview:_joinTeamMenu];
    }
    
    return _joinTeamMenu;
}

@end
