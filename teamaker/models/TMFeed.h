//
//  TMFeed.h
//  teamaker
//
//  Created by hustlzp on 15/8/24.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TMFeed : NSManagedObject

@property (nonatomic) int64_t id;
@property (nonatomic) int64_t user_id;
@property (nonatomic, retain) NSString * userAvatar;
@property (nonatomic, retain) NSString * user;
@property (nonatomic) int64_t team_id;
@property (nonatomic, retain) NSString * team;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * punch;

@end
