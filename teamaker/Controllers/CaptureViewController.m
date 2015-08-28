//
//  CaptureViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "CaptureViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "TMTeam.h"
#import "UIColor+Helper.h"
#import "ComposeViewControllerProtocol.h"
#import "TeamButtons.h"

@interface CaptureViewController () <ComposeViewControllerProtocol>

@property (nonatomic, weak) UIView *imageView;
@property (nonatomic, weak) TeamButtons *teamButtons;
@property (nonatomic, weak) UIButton *captureButton;

@property (nonatomic, strong) NSArray *teams;

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 照片
    UIView *imageView = [[UIView alloc] init];
    imageView.backgroundColor = [UIColor grayColor];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 拍摄按钮
    UIButton *captureButton = [[UIButton alloc] init];
    [captureButton setTitle:@"Capture" forState:UIControlStateNormal];
    [self.view addSubview:captureButton];
    self.captureButton = captureButton;
    [captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-20);
    }];
    [captureButton addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    
    return _teams;
}

static int const buttonHeight = 60;

// 拍摄按钮
- (IBAction)capture:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideComposePager" object:nil];
    sender.hidden = YES;
    
    TeamButtons *teamButtons = [[TeamButtons alloc] initWithController:self cancelAction:@selector(cancelAction:) publishAction:@selector(publishAction:)];
    self.teamButtons = teamButtons;
    [self.view addSubview:teamButtons];
    
    [self.view layoutIfNeeded];
    
    // 照片缩小
    CGFloat verticalOffset = 25.0;
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat horizonalOffset = imageWidth / 2 - imageWidth * (imageHeight - [self getButtonsHeight] - 2 * verticalOffset) / 2 / imageHeight;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(verticalOffset, horizonalOffset, verticalOffset + [self getButtonsHeight], horizonalOffset));
    }];
    
    CGRect frame = self.teamButtons.frame;
    frame.origin.y = frame.origin.y - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.teamButtons.frame = frame;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancelAction:(UIButton *)sender
{
    [self hideButtons];
}

- (IBAction)publishAction:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    [self hideButtons];
}

- (void)resetLayout
{
    [self hideButtons];
}

// 隐藏按钮组
- (void)hideButtons
{
    self.captureButton.hidden = NO;
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.teamButtons.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, [self getButtonsHeight]);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.teamButtons removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showComposePager" object:nil];
    }];
}

// 获取按钮组高度
- (NSInteger)getButtonsHeight
{
    return buttonHeight * (self.teams.count + 1) + 1 * self.teams.count;
}

@end
