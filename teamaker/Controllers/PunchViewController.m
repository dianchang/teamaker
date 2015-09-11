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
#import "Constants.h"
#import "Ionicons.h"

@interface PunchViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerProtocol>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addPunchButton;
@property (strong, nonatomic) UIView *backdropView;
@property (strong, nonatomic) TeamButtons *teamButtons;
@property (strong, nonatomic) NSMutableArray *punchs;
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
    [addPunchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addPunchButton.backgroundColor = [UIColor lightGrayColor];
    addPunchButton.layer.cornerRadius = 30;
    addPunchButton.layer.masksToBounds = YES;
    [addPunchButton setTitle:ion_plus forState:UIControlStateNormal];
    addPunchButton.titleLabel.font = [IonIcons fontWithSize:28];
    [self.view addSubview:addPunchButton];
    self.addPunchButton = addPunchButton;
    
    // 约束
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [addPunchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@60);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIMenuItem *testMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePunch:)];
    [[UIMenuController sharedMenuController] setMenuItems: @[testMenuItem]];
    [[UIMenuController sharedMenuController] update];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < -50) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TMVerticalScrollViewShouldPageUpNotification object:self];
    }
}

#pragma mark - private methods

- (NSMutableArray *)getPunches
{
    return [NSMutableArray arrayWithArray:[TMPunch MR_findAllSortedBy:@"order" ascending:YES]];
}

- (void)reloadData
{
    self.punchs = [self getPunches];
    [self.tableView reloadData];
}

- (void)cancelPublish:(UIButton *)sender
{
    [self hideTeamButtons];
}

- (void)publish:(UIButton *)sender
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
            [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedViewShouldReloadFeedsAndScrollToTopNotification object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:TMVerticalScrollViewShouldPageUpNotification object:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];
    }];
}

- (void)preparePublish:(id)sender
{
    [self.teamButtons showWithDuration:.3 animation:nil completion:nil];
}

- (void)resetLayout
{    
    [self hideTeamButtons];
}

// 隐藏团队按钮
- (void)hideTeamButtons
{
    if (!self.teamButtons.superview) {
        return;
    }
    
    [self.teamButtons hideWithDuration:.3 animation:nil completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldShowPagerNotification object:nil];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldHidePagerNotification object:nil];
    self.selectedPunch = punch;
    
    [self preparePublish:[tableView cellForRowAtIndexPath:indexPath]];
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
        
        [self reloadData];
    }
}

// 仅用于消除 XCode 的 warning
- (void)deletePunch:(id)sender
{
}

#pragma mark - getters and setters

- (NSMutableArray *)punchs
{
    if (!_punchs) {
        _punchs = [self getPunches];
    }
    
    return _punchs;
}

- (TeamButtons *)teamButtons
{
    if (!_teamButtons) {
        _teamButtons = [[TeamButtons alloc] initWithBackgroundFaded:YES];
        _teamButtons.delegate = self;
    }
    
    return _teamButtons;
}

@end
