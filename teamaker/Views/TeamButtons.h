//
//  TeamButtons.h
//  teamaker
//
//  Created by hustlzp on 15/8/19.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamButtons : UIView
- (instancetype)initWithController:(UIViewController *)controller cancelAction:(SEL)cancelAction publishAction:(SEL)publishAction;
@end
