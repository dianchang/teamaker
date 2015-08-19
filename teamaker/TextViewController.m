//
//  TextViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/18.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TextViewController.h"
#import "Masonry.h"
#import "ComposeViewControllerProtocol.h"

@interface TextViewController () <ComposeViewControllerProtocol>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UIButton *sendButton;
@end

@implementation TextViewController

static int const sendButtonHeight = 50;

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
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
    [self.view addSubview:sendButton];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).with.offset(10);
        make.bottom.equalTo(sendButton.mas_top);
        make.top.equalTo(self.view).with.offset(20);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
        make.height.equalTo([NSNumber numberWithInt:sendButtonHeight]);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 键盘
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
}

// 准备页面
- (void)prepareLayout
{
    [self.textView becomeFirstResponder];
}

@end
