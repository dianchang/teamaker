//
//  Seed.h
//  teamaker
//
//  Created by hustlzp on 15/9/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
#import "TMUser.h"
#import "TMTeamUserInfo.h"
#import "TMFeed.h"
#import "TMUserLikeFeed.h"
#import "TMPunch.h"
#import "TMFeedComment.h"
#import "TMTeam.h"

@interface Seed : NSObject

// User
+ (TMUser *)createUserWithName:(NSString *)name sex:(NSString *)sex avatar:(NSString *)avatar;

// Team
+ (TMTeam *)createTeamWithName:(NSString *)name avatar:(NSString *)avatar;

// TeamUserInfo
+ (void)addUser:(TMUser *)user toTeam:(TMTeam *)team;

// Feed
+ (TMFeed *)createTextFeed:(NSString *)text user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred;
+ (TMFeed *)createPunchFeed:(NSString *)punch user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred;
+ (TMFeed *)createImageFeed:(NSString *)imageUrl user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred;
+ (TMFeed *)createShareFeed:(NSString *)url title:(NSString *)title user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred;

// UserLikeFeed
+ (void)user:(TMUser *)user likeFeed:(TMFeed *)feed;

// FeedComment
+ (void)user:(TMUser *)user commentFeed:(TMFeed *)feed targetUser:(TMUser *)targetUser content:(NSString *)content;

// Punch
+ (void)createPunch:(NSString *)punch user:(TMUser *)user;

+ (void)truncateAllData;

@end
