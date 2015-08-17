//
//  TMPunch.m
//  teamaker
//
//  Created by hustlzp on 15/8/17.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TMPunch.h"

@implementation TMPunch

+ (instancetype)initWithContent:(NSString *)content
{
    TMPunch *punch = [[TMPunch alloc] init];
    punch.content = content;
    return punch;
}

+ (NSArray *)getAll
{
    return @[[TMPunch initWithContent:@"开会中"],
             [TMPunch initWithContent:@"头脑风暴ing"],
             [TMPunch initWithContent:@"开始工作！"],
             [TMPunch initWithContent:@"加油！坚持！"],
             [TMPunch initWithContent:@"上班路上"]];
}

@end
