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
#import "Masonry.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TeamButtons()

@property (strong, nonatomic) NSArray *teams;

@end

@implementation TeamButtons

static int const buttonHeight = 60;

- (instancetype)initWithTeams:(NSArray *)teams
{
    self = [super init];
    self.teams = teams;
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

- (NSInteger)getButtonsHeight
{
    return buttonHeight * (self.teams.count + 1) + 1 * self.teams.count;
}

@end
