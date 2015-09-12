//
//  Seed.m
//  teamaker
//
//  Created by hustlzp on 15/9/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "Seed.h"
#import "AFNetworking.h"

static NSString *cdn = @"http://7xlqpw.com1.z0.glb.clouddn.com";

@implementation Seed

// User
+ (TMUser *)createUserWithName:(NSString *)name sex:(NSString *)sex avatar:(NSString *)avatar
{
    static long id = 1;
    
    __block TMUser *user;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        user = [TMUser MR_createEntityInContext:localContext];
        user.id = [NSNumber numberWithLong:id];
        user.name = name;
        user.sex = sex;
        user.email = @"hustlzp@qq.com";
        user.wechat = @"hustlzp";
        user.province = @"北京";
        user.phone = @"15810246752";
        user.motto = @"呵呵";
        user.avatar = [NSString stringWithFormat:@"%@/%@", cdn, avatar];
    }];
    
    id++;
    
    return user;
}

// Team
+ (TMTeam *)createTeamWithName:(NSString *)name avatar:(NSString *)avatar
{
    static long id = 1;
    
    __block TMTeam *team;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        team = [TMTeam MR_createEntityInContext:localContext];
        team.id = [NSNumber numberWithLong:id];
        team.name = name;
        team.avatar = [NSString stringWithFormat:@"%@/%@", cdn, avatar];
    }];
    
    return team;
}

// TeamUserInfo
+ (void)addUser:(TMUser *)user toTeam:(TMTeam *)team
{
    static long id = 1;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        TMUser *_user = [user MR_inContext:localContext];
        TMTeam *_team = [team MR_inContext:localContext];
        
        TMTeamUserInfo* info = [TMTeamUserInfo MR_createEntityInContext:localContext];
        info.id = [NSNumber numberWithLong:id];
        info.name = _user.name;
        info.avatar = _user.avatar;
        info.userId = _user.id;
        info.user = _user;
        info.teamId = _team.id;
        info.team = _team;
        info.createdAt = [NSDate date];
    }];
    
    id++;
}

// Feed
+ (TMFeed *)createFeedWithUser:(TMUser *)user team:(TMTeam *)team inContext:(NSManagedObjectContext *)context
{
    static long id = 1;
    
    TMFeed *feed = [TMFeed MR_createEntityInContext:context];
    TMUser *_user = [user MR_inContext:context];
    TMTeam *_team = [team MR_inContext:context];
    
    feed.id = [NSNumber numberWithLong:id];
    feed.userId = _user.id;
    feed.user = _user;
    feed.teamId = _team.id;
    feed.team = _team;
    feed.createdAt = [NSDate date];
    
    id++;
    
    return feed;
}

// Feed - TEXT
+ (TMFeed *)createTextFeed:(NSString *)text user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred
{
    __block TMFeed *feed;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"text";
        feed.text = text;
        feed.starredValue = starred;
    }];
    
    return feed;
}

// Feed - PUNCH
+ (TMFeed *)createPunchFeed:(NSString *)punch user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred
{
    __block TMFeed *feed;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"punch";
        feed.punch = punch;
        feed.starredValue = starred;
    }];
    
    return feed;
}

// Feed - IMAGE
+ (TMFeed *)createImageFeed:(NSString *)imageUrl user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred
{
    __block TMFeed *feed;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"image";
        feed.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", cdn, imageUrl]]];;
        feed.starredValue = starred;
    }];
    
    return feed;
}

// Feed - SHARE
+ (TMFeed *)createShareFeed:(NSString *)url title:(NSString *)title user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred
{
    __block TMFeed *feed;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"share";
        feed.shareTitle = title;
        feed.shareUrl = url;
        feed.starredValue = starred;
    }];
    
    return feed;
}

// UserLikeFeed
+ (void)user:(TMUser *)user likeFeed:(TMFeed *)feed
{
    static long id = 1;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        TMUserLikeFeed *likeFeed = [TMUserLikeFeed MR_createEntityInContext:localContext];
        TMUser *_user = [user MR_inContext:localContext];
        TMFeed *_feed = [feed MR_inContext:localContext];
        
        likeFeed.id = [NSNumber numberWithLong:id];
        likeFeed.createdAt = [NSDate date];
        likeFeed.userId = _user.id;
        likeFeed.user = _user;
        likeFeed.feedId = _feed.id;
        likeFeed.feed = _feed;
    }];
    
    id++;
}

// FeedComment
+ (void)user:(TMUser *)user commentFeed:(TMFeed *)feed targetUser:(TMUser *)targetUser content:(NSString *)content
{
    static long id = 1;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        TMUser *_user = [user MR_inContext:localContext];
        TMUser *_targetUser;
        TMFeed *_feed = [feed MR_inContext:localContext];
        
        if (targetUser) {
            _targetUser = [targetUser MR_inContext:localContext];
        }
        
        TMFeedComment *comment = [TMFeedComment MR_createEntityInContext:localContext];
        comment.id = [NSNumber numberWithLong:id];
        comment.content = content;
        comment.userId = _user.id;
        comment.user = _user;
        comment.feedId = _feed.id;
        comment.feed = _feed;
        comment.createdAt = [NSDate date];
        
        if (targetUser) {
            comment.targetUserId = _targetUser.id;
            comment.targetUser = _targetUser;
        }
    }];
    
    id++;
}

// Punch
+ (void)createPunch:(NSString *)punchContent user:(TMUser *)user
{
    static long id = 1;
    static long order = 1;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        TMUser *userInContext = [user MR_inContext:localContext];
        
        TMPunch *punch = [TMPunch MR_createEntityInContext:localContext];
        punch.id = [NSNumber numberWithLong:id];
        punch.order = [NSNumber numberWithLong:order];
        punch.content = punchContent;
        punch.userId = userInContext.id;
        punch.user = userInContext;
    }];
    
    id++;
    order++;
}

// Truncate all data
+ (void)truncateAllData
{
    [TMFeed MR_truncateAll];
    [TMFeedComment MR_truncateAll];
    [TMPunch MR_truncateAll];
    [TMTeam MR_truncateAll];
    [TMTeamUserInfo MR_truncateAll];
    [TMUser MR_truncateAll];
    [TMUserLikeFeed MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
