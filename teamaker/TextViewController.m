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
#import "ComposeViewControllerProtocol.h"
#import "TeamButtons.h"
#import "UIColor+Helper.h"
#import "TMFeed.h"

@import CoreData;

@interface TextViewController () <ComposeViewControllerProtocol>
@property (weak, nonatomic) UITextView *textView;
@property (weak, nonatomic) UIButton *sendButton;
@property (weak, nonatomic) TeamButtons *teamButtons;
@property (weak, nonatomic) UIView *backdropView;
@end

@implementation TextViewController

static int const sendButtonHeight = 50;

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    self.view = contentView;
    
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
    [sendButton addTarget:self action:@selector(publishText:) forControlEvents:UIControlEventTouchUpInside];
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
    [self hideTeamButtons];
}

// 准备页面
- (void)prepareLayout
{
    [self.textView becomeFirstResponder];
}

- (IBAction)publishText:(UIButton *)sender
{
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
    self.teamButtons = teamButtons;
    [self.backdropView addSubview:teamButtons];
    
    [self.view layoutIfNeeded];
    
    [self.textView resignFirstResponder];
    
    CGRect frame = teamButtons.frame;
    frame.origin.y = frame.origin.y - frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
        teamButtons.frame = frame;
    }];
}

// 取消发送
- (IBAction)cancelAction:(UIButton *)sender
{
    [self hideTeamButtons];
    [self.textView becomeFirstResponder];
}

// 发布文字到某团队
-(IBAction)publishToTeam:(UIButton *)sender
{
    [self hideTeamButtons];
    [self.textView becomeFirstResponder];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMFeed *feed = [TMFeed MR_createEntityInContext:localContext];
        feed.kind = @"text";
        feed.user_id = 1;
        feed.user = @"hustlzp";
        feed.userAvatar = @"http://img3.douban.com/icon/up45197381-5.jpg";
        feed.team_id = sender.tag;
        feed.team = @"Teamaker";
        feed.text = self.textView.text;
    } completion:^(BOOL contextDidSave, NSError *error) {
        self.textView.text = @"";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageUp" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFeeds" object:self];
    }];
}

// 隐藏按钮
- (void)hideTeamButtons
{
    CGRect frame = self.teamButtons.frame;
    frame.origin.y = self.view.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.teamButtons.frame = frame;
        self.backdropView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
    } completion:^(BOOL finished) {
        [self.backdropView removeFromSuperview];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
