//
//  BaseFeedViewController.h
//  teamaker
//
//  Created by hustlzp on 15/9/5.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//
//  FeedView基类，需重载的方法：
//  * feeds getter
//  *

#import <UIKit/UIKit.h>
#import "FeedTableViewCellProtocol.h"
#import "TMUser.h"

@interface BaseFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FeedTableViewCellProtocol>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) TMUser* loggedInUser;

@end
