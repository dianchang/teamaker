//
//  TMFeed.h
//  teamaker
//
//  Created by hustlzp on 15/8/17.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMFeed : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic) NSUInteger user_id;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *userAvatar;
@property (nonatomic) NSUInteger team_id;
@property (strong, nonatomic) NSString *team;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *punch;

@end
