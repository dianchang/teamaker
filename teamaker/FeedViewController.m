//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "FeedViewController.h"
#import "Masonry.h"

@interface FeedViewController ()
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];

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

- (IBAction)pageDown:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PageDown" object:self];
}

@end
