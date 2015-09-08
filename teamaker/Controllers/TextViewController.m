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
#import "Constants.h"

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
    sendButton.backgroundColor = [UIColor colorWithRGBA:0x8D8E95FF];
    sendButton.titleLabel.textColor = [UIColor whiteColor];
    [sendButton addTarget:self action:@selector(preparePublish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    // 约束
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(sendButton.mas_top);
        make.top.equalTo(self.view).offset(20);
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    if (!self.textView.text.length) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldHidePagerNotification object:nil];
    
    [self.textView resignFirstResponder];
    [self.textView setEditable:NO];
    [self.teamButtons showWithDuration:.3 animation:nil completion:nil];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:TMVerticalScrollViewShouldPageUpNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedViewShouldReloadDataNotification object:self];
    }];
}

// 隐藏按钮
- (void)hideTeamButtons
{
    if (!self.teamButtons.superview) {
        return;
    }
    
    [self.teamButtons hideWithDuration:.3 animation:nil completion:^{
         [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewShouldShowPagerNotification object:nil];
    }];
}

#pragma mark - getters and setters

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    return _teams;
}

- (TeamButtons *)teamButtons
{
    if (!_teamButtons) {
        _teamButtons = [[TeamButtons alloc] initWithTeams:self.teams backgroundFaded:YES];
        _teamButtons.delegate = self;
    }
    
    return _teamButtons;
}

@end
