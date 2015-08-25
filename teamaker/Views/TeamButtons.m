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

- (instancetype)initWithController:(UIViewController *)controller cancelAction:(SEL)cancelAction publishAction:(SEL)publishAction
{
    UIView *parentView = controller.view;
    self = [super initWithFrame:CGRectMake(0, parentView.bounds.size.height, parentView.bounds.size.width, [self getButtonsHeight])];
    self.backgroundColor = [UIColor colorWithRGBA:0xAAAAAAFF];
    
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:[UIColor colorWithRGBA:0x999999FF] forState:UIControlStateNormal];
    [cancelButton addTarget:controller action:cancelAction forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
    }];
    
    // 团队选择按钮
    for (int i = 0; i < self.teams.count; i++) {
        TMTeam *team = self.teams[i];
        UIButton *teamButton = [[UIButton alloc] init];
        [teamButton setTitle:team.name forState:UIControlStateNormal];
        teamButton.backgroundColor = [UIColor whiteColor];
        [teamButton setTitleColor:[UIColor colorWithRGBA:0x000000FF] forState:UIControlStateNormal];
        teamButton.tag = team.idValue;
        [teamButton addTarget:controller action:publishAction forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:teamButton];
        [teamButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.offset(-(buttonHeight + 1) * (i + 1));
            make.height.equalTo([NSNumber numberWithInt:buttonHeight]);
        }];
    }

    return self;
}

- (NSInteger)getButtonsHeight
{
    return buttonHeight * (self.teams.count + 1) + 1 * self.teams.count;
}

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    
    return _teams;
}

@end
