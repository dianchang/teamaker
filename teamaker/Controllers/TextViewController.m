//
//  TextViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TextViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "TMTeam.h"
#import "ComposeViewControllerProtocol.h"
#import "TeamButtons.h"
#import "UIColor+Helper.h"
#import "TMFeed.h"

@import CoreData;

@interface TextViewController () <ComposeViewControllerProtocol>
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) TeamButtons *teamButtons;
@property (strong, nonatomic) NSArray *teams;
@property (weak, nonatomic) UIView *backdropView;
@end

@implementation TextViewController

static int const sendButtonHeight = 50;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 文字编辑框
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 发送按钮
    UIButton *sendButton = [[UIButton alloc] init];
    self.sendButton = sendButton;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor brownColor];
    sendButton.titleLabel.textColor = [UIColor whiteColor];
    [sendButton addTarget:self action:@selector(preparePublish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    // 约束
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).with.offset(10);
        make.bottom.equalTo(sendButton.mas_top);
        make.top.equalTo(self.view).with.offset(20);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo([NSNumber numberWithInt:sendButtonHeight]);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 键盘显示
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-height);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 重置页面
- (void)resetLayout
{
    [self.textView resignFirstResponder];
    [self.textView setEditable:YES];
    [self hideTeamButtons];
}

// 准备页面
- (void)prepareLayout
{
    [self.textView becomeFirstResponder];
}

- (void)preparePublish:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideComposePager" object:nil];
    
    // 背景
    UIView *backdropView  = [[UIView alloc] initWithFrame:CGRectZero];
    self.backdropView = backdropView;
    backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(cancelPublish:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [backdropView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:backdropView];
    [backdropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 团队按钮
    TeamButtons *teamButtons = [[TeamButtons alloc] initWithTeams:self.teams];
    [self.view addSubview:teamButtons];
    self.teamButtons = teamButtons;
    teamButtons.delegate = self;
    
    [teamButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.view layoutIfNeeded];
    
    [teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.textView resignFirstResponder];
    [self.textView setEditable:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
        [self.view layoutIfNeeded];
    }];
}

// 取消发送
- (void)cancelPublish:(UIButton *)sender
{
    [self hideTeamButtons];
    [self.textView setEditable:YES];
    [self.textView becomeFirstResponder];
}

// 发布文字到某团队
-(void)publish:(UIButton *)sender
{
    [TMFeed createTextFeed:self.textView.text teamId:[NSNumber numberWithLong:sender.tag] completion:^(BOOL contextDidSave, NSError *error) {
        self.textView.text = @"";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageUp" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFeeds" object:self];
    }];
}

// 隐藏按钮
- (void)hideTeamButtons
{
    [self.teamButtons mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    } completion:^(BOOL finished) {
        [self.backdropView removeFromSuperview];
        self.backdropView = nil;
        self.teamButtons = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showComposePager" object:nil];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    return _teams;
}

@end
