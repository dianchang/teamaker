//
//  PunchViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PunchViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "UIColor+Helper.h"
#import "TMPunch.h"
#import "TMTeam.h"
#import "TMFeed.h"
#import "ComposeViewControllerProtocol.h"
#import "PunchTableViewCell.h"
#import "TeamButtons.h"

@interface PunchViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerProtocol>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addPunchButton;
@property (strong, nonatomic) UIView *backdropView;
@property (strong, nonatomic) TeamButtons *teamButtons;
@property (strong, nonatomic) NSArray *punchs;
@property (strong, nonatomic) NSArray *teams;
@property (strong, nonatomic) TMPunch *selectedPunch;
@end

@implementation PunchViewController

static NSString *cellIdentifier = @"PunchCell";

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    // 表格
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.tableView registerClass:[PunchTableViewCell class] forCellReuseIdentifier:cellIdentifier];

    // 添加按钮
    UIButton *addPunchButton = [UIButton new];
    [addPunchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addPunchButton setTitle:@"+" forState:UIControlStateNormal];
    [self.view addSubview:addPunchButton];
    self.addPunchButton = addPunchButton;
    self.addPunchButton.titleLabel.font = [UIFont systemFontOfSize:40];
    
    // 约束
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [addPunchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIMenuItem *testMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePunch:)];
    [[UIMenuController sharedMenuController] setMenuItems: @[testMenuItem]];
    [[UIMenuController sharedMenuController] update];
}

- (NSArray *)punchs
{
    if (!_punchs) {
        _punchs = [TMPunch MR_findAllSortedBy:@"order" ascending:YES];
    }
    
    return _punchs;
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    return _teams;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < -50) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageUp" object:self];
    }
}

#pragma mark - table view delegate & data source

#define MAINLABEL_TAG 1
static float const buttonHeight = 60.0;

- (void)reloadData
{
    self.punchs = [TMPunch MR_findAllSortedBy:@"order" ascending:YES];
    [self.tableView reloadData];
}

- (void)cancelAction:(UIButton *)sender
{
    [self hideButtons];
}

- (void)publishToTeam:(UIButton *)sender
{
    [TMFeed createPunchFeed:self.selectedPunch.content teamId:[NSNumber numberWithLong:sender.tag] completion:^(BOOL contextDidSave, NSError *error) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSUInteger order = 1;
            for (TMPunch *punch in self.punchs) {
                TMPunch *punchInContext = [punch MR_inContext:localContext];
                
                if ([punchInContext.id isEqualToNumber:self.selectedPunch.id]) {
                    punchInContext.order = @0;
                } else {
                    punchInContext.order = [NSNumber numberWithLong:order];
                    order++;
                }
            }
        } completion:^(BOOL contextDidSave, NSError *error) {
            [self reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PageUp" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFeeds" object:self];
        }];
    }];
}

- (void)resetLayout
{
    [self hideButtons];
}

// 隐藏团队按钮
- (void)hideButtons
{
    [UIView animateWithDuration:0.3 animations:^{
        self.teamButtons.frame = CGRectMake(0, self.tableView.bounds.size.height, self.tableView.bounds.size.width, buttonHeight * (self.teams.count + 1) + 1 * self.teams.count);
        self.backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    } completion:^(BOOL finished) {
        [self.backdropView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showComposePager" object:nil];
    }];
}

#pragma mark - tableview delegate and datasource

// 单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMPunch *punch = self.punchs[indexPath.row];
    PunchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRGBA:0xDDDDDDFF];
    } else {
        cell.backgroundColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    }
    
    [cell updateCellWithPunch:punch];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMPunch *punch = self.punchs[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideComposePager" object:nil];
    
    self.selectedPunch = punch;
    
    UIView *backdropView  = [[UIView alloc] initWithFrame:CGRectZero];
    self.backdropView = backdropView;
    backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(cancelAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [backdropView addGestureRecognizer:tapRecognizer];
    
    [self.view addSubview:backdropView];
    [backdropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    TeamButtons *teamButtons = [[TeamButtons alloc] initWithController:self cancelAction:@selector(cancelAction:) publishAction:@selector(publishToTeam:)];
    [self.backdropView addSubview:teamButtons];
    self.teamButtons = teamButtons;
    
    CGRect frame = teamButtons.frame;
    frame.origin.y = frame.origin.y - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        teamButtons.frame = frame;
        backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
    }];
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.punchs.count;
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(deletePunch:));
}

- (void) tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(deletePunch:)) {
        TMPunch* punch = self.punchs[indexPath.row];
        [punch MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    }
}

// 仅用于消除 XCode 的 warning
- (void)deletePunch:(id)sender
{
}

@end
