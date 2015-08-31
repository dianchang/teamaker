//
//  JoinTeamMenu.h
//  teamaker
//
//  Created by hustlzp on 15/8/31.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinTeamMenu : UIView

- (instancetype)initWithCreateTeam:(void (^)(void))createTeamBlock joinTeam:(void (^)(void))joinTeamBlock inviteFriend:(void (^)(void))inviteFriendBlock;

@end
