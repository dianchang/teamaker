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
    
    TMUser *userHustlzp = [Seed createUserWithName:@"hustlzp" sex:@"男" avatar:@"hustlzp.png"];
    TMUser *userHardin = [Seed createUserWithName:@"哈丁" sex:@"男" avatar:@"hardin.png"];
    TMUser *userJiuQi = [Seed createUserWithName:@"玖琪" sex:@"女" avatar:@"jiuqi.jpg"];
    TMUser *userKasperl = [Seed createUserWithName:@"kasperl" sex:@"男" avatar:@"1.png"];
    TMUser *userALan = [Seed createUserWithName:@"阿兰" sex:@"男" avatar:@"2.png"];

    TMUser *userXiaoYang = [Seed createUserWithName:@"小杨issac" sex:@"男" avatar:@"3.png"];
    TMUser *userVee = [Seed createUserWithName:@"vee" sex:@"男" avatar:@"4.png"];
    TMUser *userKim = [Seed createUserWithName:@"kim" sex:@"男" avatar:@"5.png"];
    TMUser *userCc = [Seed createUserWithName:@"cc" sex:@"男" avatar:@"6.png"];
    TMUser *userBanlon = [Seed createUserWithName:@"banlon" sex:@"男" avatar:@"7.png"];
    
    TMUser *userOxygen = [Seed createUserWithName:@"oxygen" sex:@"男" avatar:@"8.png"];
    TMUser *userHideCloud = [Seed createUserWithName:@"hidecloud" sex:@"男" avatar:@"9.png"];
    TMUser *userFenny = [Seed createUserWithName:@"Fenny" sex:@"男" avatar:@"fenny.png"];
    TMUser *userJiangYang = [Seed createUserWithName:@"汪洋" sex:@"男" avatar:@"10.jpeg"];
    TMUser *userKant = [Seed createUserWithName:@"邹剑波Kant" sex:@"男" avatar:@"kant.png"];
    TMUser *userNomessi = [Seed createUserWithName:@"homessi" sex:@"男" avatar:@"11.jpeg"];
    TMUser *userDaiYuSen = [Seed createUserWithName:@"戴雨森" sex:@"男" avatar:@"12.jpeg"];
    TMUser *userKentZhu = [Seed createUserWithName:@"kentzhu" sex:@"男" avatar:@"13.jpeg"];
    TMUser *userAray = [Seed createUserWithName:@"豆瓣Aray" sex:@"男" avatar:@"14.jpeg"];
    
    NSLog(@"Creating teams");
    
    TMTeam *teamYouQuan = [Seed createTeamWithName:@"有圈团队" avatar:@"teamYouquan.png"];
    TMTeam *teamLagou = [Seed createTeamWithName:@"拉钩一拍项目组" avatar:@"teamLagou.jpg"];
    TMTeam *teamPM = [Seed createTeamWithName:@"PM's" avatar:@"teamPM.jpg"];

    NSLog(@"Creating teamUserInfos");
    
    [Seed addUser:userHustlzp toTeam:teamYouQuan];
    [Seed addUser:userHardin toTeam:teamYouQuan];
    [Seed addUser:userJiuQi toTeam:teamYouQuan];
    [Seed addUser:userKasperl toTeam:teamYouQuan];
    [Seed addUser:userALan toTeam:teamYouQuan];
    
    [Seed addUser:userXiaoYang toTeam:teamLagou];
    [Seed addUser:userHardin toTeam:teamLagou];
    [Seed addUser:userVee toTeam:teamLagou];
    [Seed addUser:userKim toTeam:teamLagou];
    [Seed addUser:userCc toTeam:teamLagou];
    [Seed addUser:userBanlon toTeam:teamLagou];
    
    [Seed addUser:userOxygen toTeam:teamPM];
    [Seed addUser:userHideCloud toTeam:teamPM];
    [Seed addUser:userFenny toTeam:teamPM];
    [Seed addUser:userJiangYang toTeam:teamPM];
    [Seed addUser:userKant toTeam:teamPM];
    [Seed addUser:userNomessi toTeam:teamPM];
    [Seed addUser:userDaiYuSen toTeam:teamPM];
    [Seed addUser:userHardin toTeam:teamPM];
    [Seed addUser:userKentZhu toTeam:teamPM];
    [Seed addUser:userAray toTeam:teamPM];
    
    NSLog(@"Creating punches");
    
    [Seed createPunch:@"开会中" user:userHardin];
    [Seed createPunch:@"头脑风暴ing" user:userHardin];
    [Seed createPunch:@"开始工作！" user:userHardin];
    [Seed createPunch:@"加油！坚持！" user:userHardin];
    [Seed createPunch:@"上班路上" user:userHardin];
    
    NSLog(@"Creating feeds");
    
    TMFeed *feed12 = [Seed createImageFeed:@"image.jpg" user:userJiuQi team:teamYouQuan starred:NO];
    TMFeed *feed11 = [Seed createTextFeed:@"讲实话，我觉得《从0到1》比《创业维艰》思维高度高了有10倍不止。《创业维艰》根本不适合每个创业者去读，而《从0到1》你应该读3遍。" user:userKasperl team:teamYouQuan starred:NO];
    TMFeed *feed10 = [Seed createImageFeed:@"image.jpg" user:userHardin team:teamYouQuan starred:NO];
    TMFeed *feed9 = [Seed createTextFeed:@"有人亲手体验过3D-touch么？怎么突然冒出来这么多从交互和使用感受角度来黑的？摸了再黑嘛..." user:userHideCloud team:teamPM starred:NO];
    
    TMFeed *feed8 = [Seed createImageFeed:@"image.jpg" user:userHustlzp team:teamYouQuan starred:NO];
    TMFeed *feed7 = [Seed createPunchFeed:@"开会中" user:userJiuQi team:teamYouQuan starred:NO];
    TMFeed *feed6 = [Seed createTextFeed:@"Airbnb CEO Brian Chesky 和他交了两年的女朋友 Elissa Patel 是通过 Tinder 认识的。" user:userOxygen team:teamPM starred:NO];
    TMFeed *feed5 = [Seed createImageFeed:@"image.jpg" user:userKim team:teamLagou starred:NO];
    
    TMFeed *feed4 = [Seed createTextFeed:@"今天准备提测新版本，大家做好准备。" user:userXiaoYang team:teamLagou starred:NO];
    TMFeed *feed3 = [Seed createPunchFeed:@"大会议室ing..." user:userVee team:teamLagou starred:NO];
    TMFeed *feed2 = [Seed createPunchFeed:@"开会！脑暴！" user:userXiaoYang team:teamLagou starred:NO];
    TMFeed *feed1 = [Seed createTextFeed:@"未来我们是不是可以做成「工作圈 + 职业圈」？关注一个人在工作内外的职业发展？" user:userHardin team:teamYouQuan starred:YES];
    
    NSLog(@"Creating like feeds");
    
    [Seed user:userHustlzp likeFeed:feed1];
    [Seed user:userJiuQi likeFeed:feed1];
    [Seed user:userKasperl likeFeed:feed1];
    [Seed user:userALan likeFeed:feed1];
    
    [Seed user:userXiaoYang likeFeed:feed5];
    
    [Seed user:userHardin likeFeed:feed6];
    [Seed user:userFenny likeFeed:feed6];
    [Seed user:userJiangYang likeFeed:feed6];
    [Seed user:userKant likeFeed:feed6];
    
    [Seed user:userHardin likeFeed:feed8];
    [Seed user:userJiuQi likeFeed:feed8];
    [Seed user:userKasperl likeFeed:feed8];
    
    [Seed user:userHardin likeFeed:feed10];
    [Seed user:userJiuQi likeFeed:feed10];
    [Seed user:userKasperl likeFeed:feed10];
    [Seed user:userHustlzp likeFeed:feed10];
    [Seed user:userALan likeFeed:feed10];
    
    [Seed user:userHardin likeFeed:feed11];
    [Seed user:userHustlzp likeFeed:feed11];
    
    [Seed user:userHustlzp likeFeed:feed12];
    [Seed user:userKasperl likeFeed:feed12];
    [Seed user:userALan likeFeed:feed12];
    [Seed user:userHardin likeFeed:feed12];
    
    NSLog(@"Creating feed comments");
    
    [Seed user:userHustlzp commentFeed:feed1 targetUser:nil content:@"这个想法很不错啊，真心赞！"];
    [Seed user:userJiuQi commentFeed:feed1 targetUser:nil content:@"我看行，靠谱。其实也可以做成圈子和圈子之间的关系啊，把一个圈子作为主体，可以和其他的圈子进行互动和点赞，比如有圈的产品组和拉勾的产品组就可以成为【好友组】啊！"];
    [Seed user:userHardin commentFeed:feed1 targetUser:userJiuQi content:@"我靠，这个吊啊！！"];
    [Seed user:userHustlzp commentFeed:feed1 targetUser:nil content:@"牛叉！"];
    [Seed user:userHardin commentFeed:feed1 targetUser:userHustlzp content:@"哈哈，昨天晚上躺床上睡不着想的"];
    [Seed user:userKasperl commentFeed:feed1 targetUser:nil content:@"很不错，现有的很多团队协作产品都是特别让人有工作感的，是boss-like的产品，我们主打大家都喜欢的产品的感觉。"];
    [Seed user:userALan commentFeed:feed1 targetUser:nil content:@"值得讨论，已标记"];
    
    [Seed user:userCc commentFeed:feed4 targetUser:nil content:@"好的，产品这边搞定了。"];
    [Seed user:userVee commentFeed:feed4 targetUser:nil content:@"前端今天下午才能做完，完了我们先碰个头。"];
    [Seed user:userXiaoYang commentFeed:feed4 targetUser:userVee content:@"算自测不？"];
    [Seed user:userVee commentFeed:feed4 targetUser:userXiaoYang content:@"放心，必须的。"];
    [Seed user:userBanlon commentFeed:feed4 targetUser:nil content:@"给力。"];
    
    [Seed user:userKim commentFeed:feed5 targetUser:nil content:@"设计稿大家看一下，和上次的变化不大。"];
    [Seed user:userHardin commentFeed:feed5 targetUser:nil content:@"还不错，就这个了。"];
    [Seed user:userBanlon commentFeed:feed5 targetUser:nil content:@"可以，先用这个上线。"];
    
    [Seed user:userNomessi commentFeed:feed6 targetUser:nil content:@"你们要做tinder？"];
    [Seed user:userOxygen commentFeed:feed6 targetUser:userNomessi content:@"不是"];
    [Seed user:userKant commentFeed:feed6 targetUser:nil content:@"女友，而不是妻子..."];
    [Seed user:userHardin commentFeed:feed6 targetUser:nil content:@"tinder wins，探探也快了"];
    [Seed user:userKant commentFeed:feed6 targetUser:userHardin content:@"😂😂😂"];
    
    [Seed user:userKasperl commentFeed:feed8 targetUser:nil content:@"这是在哪？"];
    [Seed user:userHustlzp commentFeed:feed8 targetUser:userKasperl content:@"故宫😀"];
    
    [Seed user:userDaiYuSen commentFeed:feed9 targetUser:nil content:@"摸了再黑？和【睡了再分】是不是一个意思？"];
    [Seed user:userKentZhu commentFeed:feed9 targetUser:userDaiYuSen content:@"哈哈哈"];
    [Seed user:userHardin commentFeed:feed9 targetUser:userDaiYuSen content:@"哈哈哈"];
    [Seed user:userAray commentFeed:feed9 targetUser:userDaiYuSen content:@"段子手我只认你"];
    
    [Seed user:userHardin commentFeed:feed10 targetUser:nil content:@"新版设计"];
    
    [Seed user:userHardin commentFeed:feed11 targetUser:nil content:@"非常认同"];

    [Seed user:userJiuQi commentFeed:feed12 targetUser:nil content:@"这算是第一次团建吧，大家来收图了~"];
    [Seed user:userHardin commentFeed:feed12 targetUser:userJiuQi content:@"很快会有第二次，第N次的。。。"];
    
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
