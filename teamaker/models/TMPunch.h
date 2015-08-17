//
//  TMPunch.h
//  teamaker
//
//  Created by hustlzp on 15/8/17.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMPunch : NSObject

@property (nonatomic, strong) NSString *content;

+ (instancetype)initWithContent:(NSString *)content;
+ (NSMutableArray *)getAll;

@end
