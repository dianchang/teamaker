//
//  TeamButtons.h
//  teamaker
//
//  Created by hustlzp on 15/8/19.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewControllerProtocol.h"

@interface TeamButtons : UIView

@property (strong, nonatomic) id <ComposeViewControllerProtocol> delegate;

- (instancetype)initWithTeams:(NSArray *)teams;

@end
