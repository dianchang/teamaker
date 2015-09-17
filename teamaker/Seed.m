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

+ (void)seedData
{
    if (![[TMUser MR_numberOfEntities] isEqualToNumber:@0]) {
        NSLog(@"Data exists.");
        return;
    }
    
    NSLog(@"Creating users.");
    
    TMUser *userHustlzp = [Seed createUserWithName:@"hustlzp" sex:@"男" avatar:@"hustlzp.png"];
    TMUser *userHardin = [Seed createUserWithName:@"哈丁" sex:@"男" avatar:@"hardin.png"];
    TMUser *userJiuQi = [Seed createUserWithName:@"玖琪" sex:@"女" avatar:@"jiuqi.jpg"];
    TMUser *userKasperl = [Seed createUserWithName:@"kasperl" sex:@"男" avatar:@"1.png"];
    TMUser *userALan = [Seed createUserWithName:@"阿兰" sex:@"男" avatar:@"7.png"];
    
    TMUser *userXiaoYang = [Seed createUserWithName:@"小杨issac" sex:@"男" avatar:@"6.png"];
    TMUser *userVee = [Seed createUserWithName:@"vee" sex:@"男" avatar:@"4.png"];
    TMUser *userKim = [Seed createUserWithName:@"kim" sex:@"男" avatar:@"5.png"];
    TMUser *userCc = [Seed createUserWithName:@"cc" sex:@"男" avatar:@"6.png"];
    TMUser *userBanlon = [Seed createUserWithName:@"banlon" sex:@"男" avatar:@"3.png"];
    
    TMUser *userOxygen = [Seed createUserWithName:@"oxygen" sex:@"男" avatar:@"2.png"];
    TMUser *userHideCloud = [Seed createUserWithName:@"hidecloud" sex:@"男" avatar:@"9.png"];
    TMUser *userFenny = [Seed createUserWithName:@"Fenng" sex:@"男" avatar:@"fenny.png"];
    TMUser *userJiangYang = [Seed createUserWithName:@"江洋" sex:@"男" avatar:@"8.png"];
    TMUser *userKant = [Seed createUserWithName:@"邹剑波Kant" sex:@"男" avatar:@"kant.png"];
    TMUser *userNomessi = [Seed createUserWithName:@"nomessi" sex:@"男" avatar:@"nomessi.png"];
    TMUser *userDaiYuSen = [Seed createUserWithName:@"戴雨森" sex:@"男" avatar:@"daiyusen.png"];
    TMUser *userKentZhu = [Seed createUserWithName:@"kentzhu" sex:@"男" avatar:@"kentzhu.png"];
    TMUser *userAray = [Seed createUserWithName:@"豆瓣Aray" sex:@"男" avatar:@"aray.png"];
    
    NSLog(@"Creating teams");
    
    TMTeam *teamYouQuan = [Seed createTeamWithName:@"有圈团队" avatar:@"teamYouquan.png"];
    TMTeam *teamLagou = [Seed createTeamWithName:@"拉勾一拍项目组" avatar:@"teamLagou.jpg"];
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
    
    [Seed
     createImageFeed:@"TuanJian"
     user:userJiuQi
     team:teamYouQuan
     starred:NO
     likers:@[userHustlzp, userKasperl, userALan, userHardin]
     comments:@[@[userJiuQi, @"这算是第一次团建吧，大家来收图了~"],
                @[userHardin, @"很快会有第二次，第N次的。。。", userJiuQi]]];
    
    [Seed
     createTextFeed:@"讲实话，我觉得《从0到1》比《创业维艰》思维高度高了有10倍不止。《创业维艰》根本不适合每个创业者去读，而《从0到1》你应该读3遍。"
     user:userKasperl
     team:teamYouQuan
     starred:NO
     likers:@[userHardin, userHustlzp]
     comments:@[@[userHardin, @"非常认同"]]];
    
    [Seed
     createImageFeed:@"XinBanSheJi"
     user:userHardin
     team:teamYouQuan
     starred:NO
     likers:@[userHardin, userJiuQi, userKasperl, userHustlzp, userALan]
     comments:@[@[userHardin, @"新版设计"]]];
    
    [Seed
     createTextFeed:@"有人亲手体验过3D-touch么？怎么突然冒出来这么多从交互和使用感受角度来黑的？摸了再黑嘛..."
     user:userHideCloud
     team:teamPM
     starred:NO
     likers:nil
     comments:@[@[userDaiYuSen, @"摸了再黑？和「睡了再分」是不是一个意思？"],
                @[userKentZhu, @"哈哈哈", userDaiYuSen],
                @[userHardin, @"哈哈哈", userDaiYuSen],
                @[userAray, @"段子手我只认你", userDaiYuSen]]];
    
    [Seed
     createImageFeed:@"GuGong"
     user:userHustlzp
     team:teamYouQuan
     starred:NO
     likers:@[userHardin, userJiuQi, userKasperl]
     comments:@[@[userKasperl, @"这是在哪？"],
                @[userHustlzp, @"故宫😀", userKasperl]]];
    
    [Seed
     createPunchFeed:@"开会中"
     user:userJiuQi
     team:teamYouQuan
     starred:NO];
    
    [Seed
     createTextFeed:@"Airbnb CEO Brian Chesky 和他交了两年的女朋友 Elissa Patel 是通过 Tinder 认识的。"
     user:userOxygen
     team:teamPM
     starred:NO
     likers:@[userHardin, userFenny, userJiangYang, userKant]
     comments:@[@[userNomessi, @"你们要做tinder？"],
                @[userOxygen, @"不是", userNomessi],
                @[userKant, @"女友，而不是妻子..."],
                @[userHardin, @"tinder wins，探探也快了"],
                @[userKant, @"😂😂😂", userHardin]]];
    
    [Seed
     createImageFeed:@"SheJi"
     user:userKim
     team:teamLagou
     starred:NO
     likers:@[userXiaoYang]
     comments:@[@[userKim, @"设计稿大家看一下，和上次的变化不大。"],
                @[userHardin, @"还不错，就这个了。"],
                @[userBanlon, @"可以，先用这个上线。"]]];
    
    [Seed
     createTextFeed:@"今天准备提测新版本，大家做好准备。"
     user:userXiaoYang
     team:teamLagou
     starred:NO
     likers:nil
     comments:@[@[userCc, @"好的，产品这边搞定了。"],
                @[userVee, @"前端今天下午才能做完，完了我们先碰个头。"],
                @[userXiaoYang, @"算自测不？", userVee],
                @[userVee, @"放心，必须的。", userXiaoYang],
                @[userBanlon, @"给力。"]]];
    
    [Seed
     createPunchFeed:@"大会议室ing..."
     user:userVee
     team:teamLagou
     starred:NO];
    
    [Seed
     createShareFeed:@"http://36kr.com/p/155310.html"
     title:@"Paul Graham：创业 = 增长"
     user:userHustlzp
     team:teamYouQuan
     starred:YES
     likers:@[userHardin, userJiuQi]
     comments:@[@[userHustlzp, @"非常好的一篇文章，强烈推荐！"]]];
    
    [Seed
     createPunchFeed:@"开会！脑暴！"
     user:userXiaoYang
     team:teamLagou
     starred:NO];
    
    [Seed
     createTextFeed:@"未来我们是不是可以做成「工作圈 + 职业圈」？关注一个人在工作内外的职业发展？"
     user:userHardin
     team:teamYouQuan
     starred:YES
     likers:@[userHustlzp, userJiuQi, userKasperl, userALan]
     comments:@[@[userHustlzp, @"这个想法很不错啊，真心赞！"],
                @[userJiuQi, @"我看行，靠谱。其实也可以做成圈子和圈子之间的关系啊，把一个圈子作为主体，可以和其他的圈子进行互动和点赞，比如有圈的产品组和拉勾的产品组就可以成为「好友组」啊！"],
                @[userHardin, @"我靠，这个吊啊！！", userJiuQi],
                @[userHustlzp, @"牛叉！"],
                @[userHardin, @"哈哈，昨天晚上躺床上睡不着想的", userHustlzp],
                @[userKasperl, @"很不错，现有的很多团队协作产品都是特别让人有工作感的，是boss-like的产品，我们主打大家都喜欢的产品的感觉。"],
                @[userALan, @"值得讨论，已标记"]]];
}

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
        user.email = @"hehe@qq.com";
        user.wechat = @"hehe";
        user.province = @"北京";
        user.phone = @"15810247635";
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
    
    id++;
    
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
+ (void)createTextFeed:(NSString *)text user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred likers:(NSArray *)likers comments:(NSArray *)comments
{
    __block TMFeed *feed;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"text";
        feed.text = text;
        feed.starredValue = starred;
    }];
    
    [self addLikers:likers toFeed:feed];
    [self addComments:comments toFeed:feed];
}

// Feed - PUNCH
+ (void)createPunchFeed:(NSString *)punch user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred
{
    __block TMFeed *feed;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"punch";
        feed.punch = punch;
        feed.starredValue = starred;
    }];
}

// Feed - IMAGE
+ (void)createImageFeed:(NSString *)imageName user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred likers:(NSArray *)likers comments:(NSArray *)comments
{
    __block TMFeed *feed;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"image";
        feed.image = UIImageJPEGRepresentation([UIImage imageNamed:imageName], 1);
        feed.starredValue = starred;
    }];
    
    [self addLikers:likers toFeed:feed];
    [self addComments:comments toFeed:feed];
}

// Feed - SHARE
+ (void)createShareFeed:(NSString *)url title:(NSString *)title user:(TMUser *)user team:(TMTeam *)team starred:(BOOL)starred likers:(NSArray *)likers comments:(NSArray *)comments
{
    __block TMFeed *feed;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        feed = [self createFeedWithUser:user team:team inContext:localContext];
        feed.kind = @"share";
        feed.shareTitle = title;
        feed.shareUrl = url;
        feed.starredValue = starred;
    }];
    
    [self addLikers:likers toFeed:feed];
    [self addComments:comments toFeed:feed];
}

+ (void)addLikers:(NSArray *)likers toFeed:(TMFeed *)feed
{
    for (TMUser *liker in likers) {
        [self user:liker likeFeed:feed];
    }
}

+ (void)addComments:(NSArray *)comments toFeed:(TMFeed *)feed
{
    for (NSArray *params in comments) {
        if (params.count < 2) {
            continue;
        }
        
        TMUser *user = [params objectAtIndex:0];
        NSString *content = [params objectAtIndex:1];
        
        TMUser *targetUser = nil;
        if (params.count == 3) {
            targetUser = [params objectAtIndex:2];
        }
        
        [self user:user commentFeed:feed targetUser:targetUser content:content];
    }
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
