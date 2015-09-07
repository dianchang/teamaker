//
//  AppDelegate.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "AppDelegate.h"
#import "TMTeam.h"
#import "TMPunch.h"
#import "TMUser.h"
#import "TMFeed.h"
#import "TMTeamUserInfo.h"
#import <MagicalRecord/MagicalRecord.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{@"LoggedInUserId": @1}];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"TMModel"];
    
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
//    [TMFeed MR_truncateAll];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    __block TMUser *user1 = nil;
    
    if ([[TMUser MR_numberOfEntities] isEqualToNumber:@0]) {
        NSLog(@"Creating users.");

        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            user1 = [TMUser MR_createEntityInContext:localContext];
            user1.id = @1;
            user1.name = @"hustlzp";
            user1.sex = @"男";
            user1.email = @"hustlzp@qq.com";
            user1.wechat = @"hustlzp";
            user1.province = @"北京";
            user1.phone = @"15810246752";
            user1.motto = @"呵呵";
            user1.avatar = @"http://img3.douban.com/icon/up45197381-5.jpg";
        }];
    }
    
    __block TMTeam *team1, *team2;
    
    if ([[TMTeam MR_numberOfEntities] isEqualToNumber:@0]) {
        NSLog(@"Creating teams");
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            team1 = [TMTeam MR_createEntityInContext:localContext];
            team1.id = @1;
            team1.name = @"Teamaker";
            team1.avatar = @"http://www.blogbar.cc/static/image/apple-touch-icon-precomposed-152.png";
            
            team2 = [TMTeam MR_createEntityInContext:localContext];
            team2.id = @2;
            team2.name = @"拉勾";
            team2.avatar = @"http://www.blogbar.cc/static/image/apple-touch-icon-precomposed-152.png";
        }];
    }

    if ([[TMTeamUserInfo MR_numberOfEntities] isEqualToNumber:@0]) {
        NSLog(@"Creating teamUserInfos");
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            TMUser *_user1 = [user1 MR_inContext:localContext];
            TMTeam *_team1 = [team1 MR_inContext:localContext];
            TMTeam *_team2 = [team2 MR_inContext:localContext];
            
            TMTeamUserInfo* info1 = [TMTeamUserInfo MR_createEntityInContext:localContext];
            info1.name = _user1.name;
            info1.avatar = _user1.avatar;
            info1.userId = _user1.id;
            info1.user = _user1;
            info1.teamId = _team1.id;
            info1.team = _team1;
            info1.membersCountInvitedViaContact = @0;
            info1.membersCountInvitedViaEmail = @0;
            
            TMTeamUserInfo* info2 = [TMTeamUserInfo MR_createEntityInContext:localContext];
            info2.name = _user1.name;
            info2.avatar = _user1.avatar;
            info2.userId = _user1.id;
            info2.user = _user1;
            info2.teamId = _team2.id;
            info2.team = _team2;
            info2.membersCountInvitedViaContact = @0;
            info2.membersCountInvitedViaEmail = @0;
        }];
    }

    if ([[TMPunch MR_numberOfEntities] isEqualToNumber:@0]) {
        NSLog(@"Creating punches");
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            TMPunch *punch1 = [TMPunch MR_createEntityInContext:localContext];
            punch1.id = @1;
            punch1.order = @1;
            punch1.content = @"开会中";
            
            TMPunch *punch2 = [TMPunch MR_createEntityInContext:localContext];
            punch2.id = @2;
            punch2.order = @2;
            punch2.content = @"头脑风暴ing";
            
            TMPunch *punch3 = [TMPunch MR_createEntityInContext:localContext];
            punch3.id = @3;
            punch3.order = @3;
            punch3.content = @"开始工作！";
            
            TMPunch *punch4 = [TMPunch MR_createEntityInContext:localContext];
            punch4.id = @4;
            punch4.order = @4;
            punch4.content = @"加油！坚持！";
            
            TMPunch *punch5 = [TMPunch MR_createEntityInContext:localContext];
            punch5.id = @5;
            punch5.order = @5;
            punch5.content = @"上班路上";
        }];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pauRse ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
