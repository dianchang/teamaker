//
//  AddTeamMemberTableViewCell.h
//  teamaker
//
//  Created by hustlzp on 15/9/7.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTeamUserInfo.h"

@interface AddTeamMemberTableViewCell : UITableViewCell

+ (NSString *)getReuseIdentifier;
- (void)updateCellWithUserInfo:(TMTeamUserInfo *)userInfo;

@end
