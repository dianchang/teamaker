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
#import "TMFeed.h"
#import "MyProfileViewController.h"
#import "UIColor+Helper.h"
#import "UIImageView+AFNetworking.h"
#import "FeedTableViewCellProtocol.h"
#import "FeedTableViewCell.h"
#import "UserProfileViewController.h"
#import "TeamProfileViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, FeedTableViewCellProtocol>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *feeds;
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

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    // 导航栏
    self.navigationItem.title = @"圈子";
    UIBarButtonItem *myProfileButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(redirectToMyProfile)];
    self.navigationItem.rightBarButtonItem = myProfileButtonItem;

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

// 向下翻页
- (IBAction)pageDown:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PageDown" object:self];
}

// 获取feeds
- (void)loadFeeds
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager GET:@"http://localhost:5000/api/user/1/feeds" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *response = (NSArray *)responseObject;
//        [self.feeds removeAllObjects];
//        for (NSDictionary *item in response) {
//            TMFeed *feed = [[TMFeed alloc] init];
//            feed.id = [[item objectForKey:@"id"] integerValue];
//            feed.user_id = [[item objectForKey:@"user_id"] integerValue];
//            feed.user = [item objectForKey:@"user"];
//            feed.userAvatar = [item objectForKey:@"user_avatar"];
//            feed.team_id = [[item objectForKey:@"team_id"] integerValue];
//            feed.team = [item objectForKey:@"team"];
//            feed.kind = [item objectForKey:@"kind"];
//            feed.text = [item objectForKey:@"text"];
//            feed.image = [item objectForKey:@"image"];
//            feed.punch = [item objectForKey:@"punch"];
//            feed.location = [item objectForKey:@"location"];
//            [self.feeds addObject:feed];
//        }
//        [self.refreshControl endRefreshing];
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
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

@end