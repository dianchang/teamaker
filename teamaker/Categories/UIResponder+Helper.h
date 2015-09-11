//
//  UIResponder+Helper.h
//  teamaker
//
//  Created by hustlzp on 15/9/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Helper)

- (BOOL)becomeFirstResponderInViewController:(UIViewController *)controller;
- (BOOL)resignFirstResponderInViewController:(UIViewController *)controller;

@end
