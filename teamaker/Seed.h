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

+ (void)seedData;
+ (void)truncateAllData;

@end
