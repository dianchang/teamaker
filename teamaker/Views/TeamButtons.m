//
//  TeamButtons.m
//  teamaker
//
//  Created by hustlzp on 15/8/19.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TeamButtons.h"
#import "UIColor+Helper.h"
#import "TMTeam.h"
#import "TMUser.h"
#import "Masonry.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TeamButtons()

@property (strong, nonatomic) NSArray *teams;
@property (nonatomic) BOOL backgroundFaded;
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation TeamButtons

static int const buttonHeight = 60;

- (instancetype)initWithBackgroundFaded:(BOOL)backgroundFaded
{
    self = [super init];
    self.backgroundFaded = backgroundFaded;
    self.backgroundColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    
    __block UIButton *prevButton;
    __block UIButton *lastButton;

    // 团队选择按钮
    for (int i = 0; i < self.teams.count; i++) {
        TMTeam *team = self.teams[i];
        UIButton *teamButton = [UIButton new];
        [teamButton setTitle:team.name forState:UIControlStateNormal];
        teamButton.backgroundColor = [UIColor whiteColor];
        [teamButton setTitleColor:[UIColor colorWithRGBA:0x000000FF] forState:UIControlStateNormal];
        teamButton.tag = team.idValue;
        [teamButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:teamButton];
        
        // 约束
        [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
            
            if (i == 0) {
                make.top.equalTo(self);
            } else {
                make.top.equalTo(prevButton.mas_bottom).offset(1);
            }
            
            if (i == self.teams.count - 1) {
                lastButton = teamButton;
            }
            
            prevButton = teamButton;
        }];
    }
    
    // 取消按钮
    UIButton *cancelButton = [UIButton new];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:[UIColor colorWithRGBA:0x999999FF] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPublish:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    // 约束
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
        make.top.equalTo(lastButton.mas_bottom).offset(1);
    }];
    
    return self;
}

- (void)publish:(UIButton *)sender
{
    [self.delegate publish:sender];
}

- (void)cancelPublish:(UIButton *)sender
{
    [self.delegate cancelPublish:sender];
}

- (void)showWithDuration:(NSTimeInterval)duration animation:(void (^)(void))animationBlock completion:(void (^)(void))completionBlock
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (self.backgroundFaded) {
        [window addSubview:self.backgroundView];
        
        [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
    }
    
    [window addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(window);
        make.top.equalTo(window.mas_bottom);
    }];
    
    [window layoutIfNeeded];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(window);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        if (animationBlock) {
            animationBlock();
        }
        
        if (self.backgroundFaded) {
            self.backgroundView.backgroundColor = [UIColor colorWithRGBA:0x00000066];
        }
        
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)hideWithDuration:(NSTimeInterval)duration animation:(void (^)(void))animationBlock completion:(void (^)(void))completionBlock
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(window);
        make.top.equalTo(window.mas_bottom);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        if (animationBlock) {
            animationBlock();
        }
        
        if (self.backgroundFaded) {
            self.backgroundView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
        }
        
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark - getters and setters

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        UIView *backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor colorWithRGBA:0x00000000];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(cancelPublish:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [backgroundView addGestureRecognizer:tapRecognizer];
        
        _backgroundView = backgroundView;
    }
    
    return _backgroundView;
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [[TMUser getLoggedInUser] findMyTeams];
    }
    
    return _teams;
}

@end
