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
#import "TMUserLikeFeed.h"
#import "TMFeedComment.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Seed.h"

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
    
    [Seed truncateAllData];
    
    NSLog(@"Creating users.");
    
    __block TMUser *userHustlzp;
    __block TMUser *userHardin;
    __block TMUser *userJiuQI;
    __block TMUser *userKasperl;
    __block TMUser *userALan;
//    __block TMUser *userXiaoYang;
    
    [Seed createUser:userHustlzp withName:@"hustlzp" sex:@"男" avatar:@""];
    [Seed createUser:userHardin withName:@"哈丁" sex:@"男" avatar:@""];
    [Seed createUser:userJiuQI withName:@"hustlzp" sex:@"男" avatar:@""];
    [Seed createUser:userKasperl withName:@"hustlzp" sex:@"男" avatar:@""];
    [Seed createUser:userALan withName:@"hustlzp" sex:@"男" avatar:@""];
    
    NSLog(@"Creating teams");
    
    __block TMTeam *teamYouQuan;
    __block TMTeam *teamLagou;
    __block TMTeam *teamPM;
    
    [Seed createTeam:teamYouQuan withName:@"有圈团队" avatar:@""];
    [Seed createTeam:teamLagou withName:@"拉钩一拍项目组" avatar:@""];
    [Seed createTeam:teamPM withName:@"PM's" avatar:@""];

    NSLog(@"Creating teamUserInfos");
    
    [Seed addUser:userHustlzp toTeam:teamYouQuan];
    [Seed addUser:userHardin toTeam:teamYouQuan];
    [Seed addUser:userHardin toTeam:teamLagou];
    
    NSLog(@"Creating feeds");
    
    __block TMFeed *feed1;
    __block TMFeed *feed2;
    
    [Seed createTextFeed:feed1 text:@"" user:userHustlzp team:teamYouQuan];
    
    NSLog(@"Creating like feeds");
    
    [Seed user:userHustlzp likeFeed:feed1];
    
    NSLog(@"Creating feed comments");
    
    [Seed user:userHustlzp commentFeed:feed1 targetUser:nil content:@""];
    [Seed user:userHustlzp commentFeed:feed2 targetUser:nil content:@""];

    NSLog(@"Creating punches");
    
    [Seed createPunch:@"" user:userHardin];
    [Seed createPunch:@"" user:userHardin];
    [Seed createPunch:@"" user:userHardin];
    [Seed createPunch:@"" user:userHardin];
    [Seed createPunch:@"" user:userHardin];

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
