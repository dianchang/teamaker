//
//  TMTeam.m
//  teamaker
//
//  Created by hustlzp on 15/8/17.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TMTeam.h"

@implementation TMTeam

+ (instancetype)initWithName:(NSString *)name
{
    TMTeam *team = [[TMTeam alloc] init];
    team.name = name;
    return team;
}

+ (NSArray *)getAll
{
    return @[[TMTeam initWithName:@"teamaker"],
             [TMTeam initWithName:@"拉钩产品团队"]];
}

@end
