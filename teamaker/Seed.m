//
//  Seed.m
//  teamaker
//
//  Created by hustlzp on 15/9/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "Seed.h"

@implementation Seed

// User
+ (void)createUser:(TMUser *)user withName:(NSString *)name sex:(NSString *)sex avatar:(NSString *)avatar
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        userHustlzp = [TMUser MR_createEntityInContext:localContext];
//        userHustlzp.id = @1;
//        userHustlzp.name = @"hustlzp";
//        userHustlzp.sex = @"男";
//        userHustlzp.email = @"hustlzp@qq.com";
//        userHustlzp.wechat = @"hustlzp";
//        userHustlzp.province = @"北京";
//        userHustlzp.phone = @"15810246752";
//        userHustlzp.motto = @"呵呵";
//        userHustlzp.avatar = @"http://img3.douban.com/icon/up45197381-5.jpg";
//        
//        userHardin = [TMUser MR_createEntityInContext:localContext];
//        userHardin.id = @2;
//        userHardin.name = @"哈丁";
//        userHardin.sex = @"男";
//        userHardin.email = @"hardin@qq.com";
//        userHardin.wechat = @"hardin";
//        userHardin.province = @"北京";
//        userHardin.phone = @"15810246752";
//        userHardin.motto = @"呵呵";
//        userHardin.avatar = @"http://www.1jingdian.com/uploads/collectionCovers/default.png";
//    }];
}

// Team
+ (void)createTeam:(TMTeam *)team withName:(NSString *)name avatar:(NSString *)avatar
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        teamYouQuan = [TMTeam MR_createEntityInContext:localContext];
//        teamYouQuan.id = @1;
//        teamYouQuan.name = @"Teamaker";
//        teamYouQuan.avatar = @"http://www.blogbar.cc/static/image/apple-touch-icon-precomposed-152.png";
//        
//        teamLagou = [TMTeam MR_createEntityInContext:localContext];
//        teamLagou.id = @2;
//        teamLagou.name = @"拉勾";
//        teamLagou.avatar = @"http://www.blogbar.cc/static/image/apple-touch-icon-precomposed-152.png";
//        
//        teamPM = [TMTeam MR_createEntityInContext:localContext];
//        teamPM.id = @3;
//        teamPM.name = @"测试";
//        teamPM.avatar = @"http://www.blogbar.cc/static/image/apple-touch-icon-precomposed-152.png";
//    }];
}

// TeamUserInfo
+ (void)addUser:(TMUser *)user toTeam:(TMTeam *)team
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        TMUser *_user1 = [userHustlzp MR_inContext:localContext];
//        TMUser *_user2 = [userHardin MR_inContext:localContext];
//        TMTeam *_team1 = [teamYouQuan MR_inContext:localContext];
//        TMTeam *_team2 = [teamLagou MR_inContext:localContext];
//        
//        TMTeamUserInfo* info1 = [TMTeamUserInfo MR_createEntityInContext:localContext];
//        info1.name = _user1.name;
//        info1.avatar = _user1.avatar;
//        info1.userId = _user1.id;
//        info1.user = _user1;
//        info1.teamId = _team1.id;
//        info1.team = _team1;
//        
//        TMTeamUserInfo* info2 = [TMTeamUserInfo MR_createEntityInContext:localContext];
//        info2.name = _user2.name;
//        info2.avatar = _user2.avatar;
//        info2.userId = _user2.id;
//        info2.user = _user2;
//        info2.teamId = _team1.id;
//        info2.team = _team1;
//        
//        TMTeamUserInfo* info3 = [TMTeamUserInfo MR_createEntityInContext:localContext];
//        info3.name = _user1.name;
//        info3.avatar = _user1.avatar;
//        info3.userId = _user1.id;
//        info3.user = _user1;
//        info3.teamId = _team2.id;
//        info3.team = _team2;
//        
//        TMTeamUserInfo* info4 = [TMTeamUserInfo MR_createEntityInContext:localContext];
//        info4.name = _user2.name;
//        info4.avatar = _user2.avatar;
//        info4.userId = _user2.id;
//        info4.user = _user2;
//        info4.teamId = _team2.id;
//        info4.team = _team2;
//    }];
}

// Feed - TEXT
+ (void)createTextFeed:(TMFeed *)feed text:(NSString *)text user:(TMUser *)user team:(TMTeam *)team
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        TMUser *_user1 = [userHustlzp MR_inContext:localContext];
//        TMUser *_user2 = [userHardin MR_inContext:localContext];
//        TMTeam *_team1 = [teamYouQuan MR_inContext:localContext];
//        //            TMTeam *_team2 = [team2 MR_inContext:localContext];
//        
//        feed1 = [TMFeed MR_createEntityInContext:localContext];
//        feed1.id = @1;
//        feed1.userId = _user1.id;
//        feed1.user = _user1;
//        feed1.teamId = _team1.id;
//        feed1.team = _team1;
//        feed1.createdAt = [NSDate date];
//        feed1.kind = @"text";
//        feed1.text = @"hehe";
//        
//        feed2 = [TMFeed MR_createEntityInContext:localContext];
//        feed2.id = @2;
//        feed2.userId = _user2.id;
//        feed2.user = _user2;
//        feed2.teamId = _team1.id;
//        feed2.team = _team1;
//        feed2.starred = @YES;
//        feed2.createdAt = [NSDate date];
//        feed2.kind = @"text";
//        feed2.text = @"xixi";
//    }];
}

// Feed - PUNCH
+ (void)createPunchFeed:(TMFeed *)feed punch:(NSString *)punch user:(TMUser *)user team:(TMTeam *)team
{

}

// Feed - IMAGE
+ (void)createImageFeed:(TMFeed *)feed imageUrl:(NSString *)imageUrl user:(TMUser *)user team:(TMTeam *)team
{

}

// Feed - SHARE
+ (void)createShareFeed:(TMFeed *)feed url:(NSString *)url title:(NSString *)title user:(TMUser *)user team:(TMTeam *)team
{

}

// UserLikeFeed
+ (void)user:(TMUser *)user likeFeed:(TMFeed *)feed
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        TMUserLikeFeed *likeFeed = [TMUserLikeFeed MR_createEntityInContext:localContext];
//        TMUser *_user2 = [userHardin MR_inContext:localContext];
//        TMFeed *_feed1 = [feed1 MR_inContext:localContext];
//        likeFeed.createdAt = [NSDate date];
//        likeFeed.userId = _user2.id;
//        likeFeed.user = _user2;
//        likeFeed.feedId = _feed1.id;
//        likeFeed.feed = _feed1;
//    }];
}

// FeedComment
+ (void)user:(TMUser *)user commentFeed:(TMFeed *)feed targetUser:(TMUser *)targetUser content:(NSString *)content
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        TMUser *_user1 = [userHustlzp MR_inContext:localContext];
//        TMUser *_user2 = [userHardin MR_inContext:localContext];
//        TMFeed *_feed1 = [feed1 MR_inContext:localContext];
//        
//        TMFeedComment *comment1 = [TMFeedComment MR_createEntityInContext:localContext];
//        comment1.id = @1;
//        comment1.content = @"呵呵。";
//        comment1.userId = _user2.id;
//        comment1.user = _user2;
//        comment1.feedId = _feed1.id;
//        comment1.feed = _feed1;
//        comment1.createdAt = [NSDate date];
//        
//        TMFeedComment *comment2 = [TMFeedComment MR_createEntityInContext:localContext];
//        comment2.id = @2;
//        comment2.content = @"呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵！";
//        comment2.userId = _user1.id;
//        comment2.user = _user1;
//        comment2.targetUserId = _user2.id;
//        comment2.targetUser = _user2;
//        comment2.feedId = _feed1.id;
//        comment2.feed = _feed1;
//        comment2.createdAt = [NSDate date];
//    }];
}

// Punch
+ (void)createPunch:(NSString *)punch user:(TMUser *)user
{
//    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        TMPunch *punch1 = [TMPunch MR_createEntityInContext:localContext];
//        punch1.id = @1;
//        punch1.order = @1;
//        punch1.content = @"开会中";
//        
//        TMPunch *punch2 = [TMPunch MR_createEntityInContext:localContext];
//        punch2.id = @2;
//        punch2.order = @2;
//        punch2.content = @"头脑风暴ing";
//        
//        TMPunch *punch3 = [TMPunch MR_createEntityInContext:localContext];
//        punch3.id = @3;
//        punch3.order = @3;
//        punch3.content = @"开始工作！";
//        
//        TMPunch *punch4 = [TMPunch MR_createEntityInContext:localContext];
//        punch4.id = @4;
//        punch4.order = @4;
//        punch4.content = @"加油！坚持！";
//        
//        TMPunch *punch5 = [TMPunch MR_createEntityInContext:localContext];
//        punch5.id = @5;
//        punch5.order = @5;
//        punch5.content = @"上班路上";
//    }];
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
