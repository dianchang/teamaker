//
//  JoinTeamMenu.m
//  teamaker
//
//  Created by hustlzp on 15/8/31.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "JoinTeamMenu.h"
#import "Masonry.h"

@interface JoinTeamMenu ()

@property (copy, nonatomic) void (^createTeamBlock)(void);
@property (copy, nonatomic) void (^joinTeamBlock)(void);
@property (copy, nonatomic) void (^inviteFriendBlock)(void);

@end

@implementation JoinTeamMenu

- (instancetype)initWithCreateTeam:(void (^)(void))createTeamBlock joinTeam:(void (^)(void))joinTeamBlock inviteFriend:(void (^)(void))inviteFriendBlock
{
    self = [super init];
    
    self.createTeamBlock = createTeamBlock;
    self.joinTeamBlock = joinTeamBlock;
    self.inviteFriendBlock = inviteFriendBlock;
    
    // 创建圈子
    UIButton *createTeamButton = [UIButton new];
    [createTeamButton setTitle:@"创建圈子" forState:UIControlStateNormal];
    createTeamButton.backgroundColor = [UIColor whiteColor];
    [createTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    createTeamButton.titleLabel.textColor = [UIColor grayColor];
    createTeamButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [createTeamButton addTarget:self action:@selector(createTeam) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:createTeamButton];
    
    // 加入圈子
    UIButton *joinTeamButton = [UIButton new];
    [joinTeamButton setTitle:@"加入圈子" forState:UIControlStateNormal];
    joinTeamButton.backgroundColor = [UIColor whiteColor];
    [joinTeamButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    joinTeamButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [joinTeamButton addTarget:self action:@selector(joinTeam) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:joinTeamButton];
    
    // 邀请朋友
    UIButton *inviteFriendButton = [UIButton new];
    [inviteFriendButton setTitle:@"邀请朋友" forState:UIControlStateNormal];
    inviteFriendButton.backgroundColor = [UIColor whiteColor];
    [inviteFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    inviteFriendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [inviteFriendButton addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteFriendButton];
    
    // 约束
    [createTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self);
        make.height.equalTo(@45);
    }];
    
    [joinTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTeamButton.mas_bottom);
        make.left.and.right.equalTo(self);
        make.height.equalTo(@45);
    }];
    
    [inviteFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinTeamButton.mas_bottom);
        make.left.right.and.bottom.equalTo(self);
        make.height.equalTo(@45);
    }];
    
    return self;
}

- (void)createTeam
{
    if (self.createTeamBlock) {
        self.createTeamBlock();
    }
}

- (void)joinTeam
{
    if (self.joinTeamBlock) {
        self.joinTeamBlock();
    }
}

- (void)inviteFriend
{
    if (self.inviteFriendBlock) {
        self.inviteFriendBlock();
    }
}

@end
