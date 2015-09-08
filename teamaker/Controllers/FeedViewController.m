//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "FeedViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MyProfileViewController.h"
#import "JoinTeamMenu.h"
#import "CreateTeamViewController.h"
#import "JoinTeamViewController.h"
#import "Constants.h"
#import "IonIcons.h"
#import "Masonry.h"
#import "TMFeed.h"
#import "JoinTeamMenu.h"
#import "JoinTeamViewController.h"
#import "UIColor+Helper.h"
#import "ExternalLinkViewController.h"

@interface FeedViewController ()

@property (strong, nonatomic) UIView *backdropView;
@property (strong, nonatomic) JoinTeamMenu *joinTeamMenu;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertLatestFeed) name:TMFeedViewShouldReloadDataNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMFeedViewShouldReloadDataNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self hideJoinTeamMenu];
}

- (void)loadView
{
    [super loadView];
    
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
    
    // 下翻按钮
    UIButton *pageDown = [UIButton new];
    [pageDown setTitle:ion_ios_arrow_down forState:UIControlStateNormal];
    pageDown.titleLabel.textColor = [UIColor colorWithRGBA:0xBBBBBBFF];
    pageDown.titleLabel.font = [IonIcons fontWithSize:28.0f];
    [pageDown setBackgroundColor:[UIColor lightGrayColor]];
    [pageDown addTarget:self action:@selector(pageDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pageDown];
    
    // 约束
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.bottom.equalTo(pageDown.mas_top);
    }];

    [pageDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
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
            make.top.equalTo(self.view).offset(TMStatusBarAndNavigationBarHeight);
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
    [[NSNotificationCenter defaultCenter] postNotificationName:TMVerticalScrollViewShouldPageDownNotification object:self];
}

/**
 *  插入最新的feed
 */
- (void)insertLatestFeed
{
    self.feeds = [[TMFeed findByUserId:self.loggedInUser.id] mutableCopy];
    
    // Just don't know why the below code will crash.
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    });
}

#pragma mark - FeedTableViewCellProtocol

- (void)redirectToExternalLinkView:(NSNumber *)feedId
{
    TMFeed *feed = [TMFeed MR_findFirstByAttribute:@"id" withValue:feedId];
    ExternalLinkViewController *controller = [[ExternalLinkViewController alloc] initWithURL:feed.shareUrl feedCreationCompletion:^{
        [self insertLatestFeed];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:controller animated:YES];
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

- (NSArray *)feeds
{
    NSArray *feeds = [super feeds];
    if (!feeds) {
        self.feeds = [TMFeed findByUserId:self.loggedInUser.id];
    }
    
    return [super feeds];
}

@end
