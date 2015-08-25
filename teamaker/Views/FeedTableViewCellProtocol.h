//
//  FeedTableViewCellProtocol.h
//  teamaker
//
//  Created by hustlzp on 15/8/23.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FeedTableViewCellProtocol <NSObject>
- (void)redirectToUserProfile:(NSNumber *)userId;
- (void)redirectToTeamProfile:(NSNumber *)teamId;
@end
