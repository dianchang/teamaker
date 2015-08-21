//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "FeedViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "TMFeed.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *feeds;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self getUserFeeds];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];

    // 表格
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    UITableView *tableView = [[UITableView alloc] init];
    tableViewController.view = tableView;
    [self addChildViewController:tableViewController];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
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

- (IBAction)pageDown:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PageDown" object:self];
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FeedCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        TMFeed *feed = self.feeds[indexPath.row];
        
        if ([feed.kind isEqualToString:@"text"]) {
            cell.textLabel.text = feed.text;
        } else if ([feed.kind isEqualToString:@"punch"]) {
            cell.textLabel.text = feed.punch;
        }
    } 
    
    return cell;
}

@end
