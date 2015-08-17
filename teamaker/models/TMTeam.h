//
//  TMTeam.h
//  teamaker
//
//  Created by hustlzp on 15/8/17.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMTeam : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *name;

+ (instancetype)initWithName:(NSString *)name;
+ (NSArray *)getAll;

@end
