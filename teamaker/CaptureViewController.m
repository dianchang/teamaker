//
//  CaptureViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "CaptureViewController.h"
#import "Masonry.h"
#import "TMTeam.h"
#import "UIColor+Helper.h"
#import "ComposeViewControllerProtocol.h"

@interface CaptureViewController () <ComposeViewControllerProtocol>

@property (nonatomic, weak) UIView *imageView;
@property (nonatomic, weak) UIView *buttonsView;
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
        _teams = [TMTeam getAll];
    }
    
    return _teams;
}

static int const buttonHeight = 60;

// 拍摄按钮
- (IBAction)capture:(UIButton *)sender
{
    sender.hidden = YES;
    
    // 按钮组
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, [self getButtonsHeight])];
    buttonsView.backgroundColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    self.buttonsView = buttonsView;
    [self.view addSubview:buttonsView];
    
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:[UIColor colorWithRGBA:0x999999FF] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(buttonsView);
        make.bottom.equalTo(buttonsView.mas_bottom).with.offset(0.0);
        make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
    }];
    
    // 团队选择按钮
    for (int i = 0; i < self.teams.count; i++) {
        TMTeam *team = self.teams[i];
        UIButton *teamButton = [[UIButton alloc] init];
        [teamButton setTitle:team.name forState:UIControlStateNormal];
        teamButton.backgroundColor = [UIColor whiteColor];
        [teamButton setTitleColor:[UIColor colorWithRGBA:0x000000FF] forState:UIControlStateNormal];
        [teamButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:teamButton];
        [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(buttonsView);
            make.bottom.equalTo(buttonsView.mas_bottom).with.offset(-(buttonHeight + 1) * (i + 1));
            make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
        }];
    }
    
    [self.view layoutIfNeeded];
    
    // 照片缩小
    CGFloat verticalOffset = 25.0;
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat imageHeight = self.imageView.bounds.size.height;
    CGFloat horizonalOffset = imageWidth / 2 - imageWidth * (imageHeight - [self getButtonsHeight] - 2 * verticalOffset) / 2 / imageHeight;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(verticalOffset, horizonalOffset, verticalOffset + [self getButtonsHeight], horizonalOffset));
    }];
    
    CGRect newFrame = buttonsView.frame;
    newFrame.origin.y = newFrame.origin.y - newFrame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        buttonsView.frame = newFrame;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancel:(UIButton *)sender
{
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
        self.buttonsView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, [self getButtonsHeight]);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.buttonsView removeFromSuperview];
    }];
}

// 获取按钮组高度
- (NSInteger)getButtonsHeight
{
    return buttonHeight * (self.teams.count + 1) + 1 * self.teams.count;
}

@end
