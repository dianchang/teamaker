//
//  PunchTableViewCell.h
//  teamaker
//
//  Created by hustlzp on 15/8/28.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMPunch.h"

@interface PunchTableViewCell : UITableViewCell

- (void)updateCellWithPunch:(TMPunch *)punch;

@end
