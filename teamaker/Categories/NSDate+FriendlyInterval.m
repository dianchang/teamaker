//
//  NSDate+FriendlyInterval.m
//  teamaker
//
//  Created by hustlzp on 15/8/26.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "NSDate+FriendlyInterval.h"

@implementation NSDate (FriendlyInterval)

- (NSString *)friendlyInterval
{
    NSString *friendlyFormat;
    NSTimeInterval interval = [self timeIntervalSinceNow];
    
    if (interval < 60) {
        friendlyFormat = @"刚刚";
    } else if (interval < 3600) {
        friendlyFormat = [[NSString alloc] initWithFormat:@"%d分钟前", (int)interval / 60];
    } else if (interval < 3600 * 24) {
        friendlyFormat = [[NSString alloc] initWithFormat:@"%d小时前", (int)interval / 3600];
    } else if (interval < 3600 * 24 * 30) {
        int dayInterval = (int)interval / (3600 * 24);
        
        if (dayInterval == 1) {
            friendlyFormat = @"昨天";
        } else if (dayInterval == 2) {
            friendlyFormat = @"前天";
        } else {
            friendlyFormat = [[NSString alloc] initWithFormat:@"%d天前", dayInterval];
        }
    } else if (interval < 3600 * 24 * 365) {
        friendlyFormat = [[NSString alloc] initWithFormat:@"%d个月前", (int)interval / (3600 * 24 * 30)];
    } else {
        friendlyFormat = [[NSString alloc] initWithFormat:@"%d年前", (int)interval / (3600 * 24 * 365)];
    }
    
    return friendlyFormat;
}

@end
