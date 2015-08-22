//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FeedViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "TMFeed.h"
#import "MyProfileViewController.h"
#import "UIColor+Helper.h"
#import "UIImageView+AFNetworking.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *feeds;
@end

//#define avatarViewTag

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self getUserFeeds];
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
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor clearColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getUserFeeds) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    [tableViewController didMoveToParentViewController:self];

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
- (IBAction)getUserFeeds
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"http://localhost:5000/api/user/1/feeds" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = (NSArray *)responseObject;
        [self.feeds removeAllObjects];
        for (NSDictionary *item in response) {
            TMFeed *feed = [[TMFeed alloc] init];
            feed.id = [[item objectForKey:@"id"] integerValue];
            feed.user_id = [[item objectForKey:@"user_id"] integerValue];
            feed.user = [item objectForKey:@"user"];
            feed.team_id = [[item objectForKey:@"team_id"] integerValue];
            feed.team = [item objectForKey:@"team"];
            feed.kind = [item objectForKey:@"kind"];
            feed.text = [item objectForKey:@"text"];
            feed.image = [item objectForKey:@"image"];
            feed.punch = [item objectForKey:@"punch"];
            feed.location = [item objectForKey:@"location"];
            [self.feeds addObject:feed];
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

# pragma mark - tableview datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feeds count];
}

static NSString *cellIdentifier = @"FeedCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
//    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [self configureCell:cell atIndexPath:indexPath];
//    } else {
//        [self updateCell:cell atIndexPath:indexPath];
//    }
    
    return cell;
}

// 新建cell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TMFeed *feed = self.feeds[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 用户头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    [avatarView setImageWithURL:[NSURL URLWithString:@"https://placeholdit.imgix.net/~text?txtsize=33&txt=30%C3%9730&w=30&h=30"]];
    avatarView.layer.cornerRadius = 15;
    avatarView.layer.masksToBounds = YES;
    [cell.contentView addSubview:avatarView];
    
    // 用户名
    UIButton *userButton = [[UIButton alloc] init];
    userButton.tag = feed.user_id;
    [userButton setTitleColor:[UIColor colorWithRGBA:0x333333FF] forState:UIControlStateNormal];
    [userButton setTitle:feed.user forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(redirectToUserProfile) forControlEvents:UIControlEventTouchUpInside];
    userButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:userButton];
    
    // 团队名
    UIButton *teamButton = [[UIButton alloc] init];
    teamButton.tag = feed.team_id;
    [teamButton setTitleColor:[UIColor colorWithRGBA:0xAAAAAAFF] forState:UIControlStateNormal];
    [teamButton setTitle:feed.team forState:UIControlStateNormal];
    [teamButton addTarget:self action:@selector(redirectToTeamProfile) forControlEvents:UIControlEventTouchUpInside];
    teamButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:teamButton];

    // gap
    UIView *gapView = [[UIView alloc] init];
    gapView.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    [cell.contentView addSubview:gapView];
    
    // 约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(15);
        make.top.equalTo(cell.contentView).with.offset(15);
        
        make.width.equalTo(@30).priorityHigh();
        make.height.equalTo(@30).priorityHigh();
    }];
    
    [userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(15);
        make.top.equalTo(cell.contentView).with.offset(15);
        make.height.equalTo(@18).priorityHigh();
    }];
    
    [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(15);
        make.top.equalTo(userButton.mas_bottom).with.offset(5);
        make.height.equalTo(@14).priorityHigh();
    }];
    
    [gapView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (indexPath.row == self.feeds.count - 1) {
            make.height.equalTo(@0).priorityHigh();
        } else {
            make.height.equalTo(@15).priorityHigh();
        }
        make.left.right.and.bottom.equalTo(cell.contentView);
        make.top.equalTo(teamButton.mas_bottom).with.offset(15.0);
    }];
}

// 跳转到用户主页
- (void)redirectToUserProfile
{
    NSLog(@"user");
}

// 跳转到
- (void)redirectToTeamProfile
{
    NSLog(@"team");
}

// 更新cell
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *sizingCell = nil;
//    static dispatch_once_t onceToken;
    
//    dispatch_once(&onceToken, ^{
        sizingCell = [[UITableViewCell alloc] init];
////    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f;
}

@end
