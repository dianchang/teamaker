//
//  UIResponder+Helper.m
//  teamaker
//
//  Created by hustlzp on 15/9/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "UIResponder+Helper.h"
#import "G.h"

@implementation UIResponder (Helper)

- (BOOL)becomeFirstResponderInViewController:(UIViewController *)controller
{
    [G sharedInstance].firstResponderViewController = controller;
    
    return [self becomeFirstResponder];
}

- (BOOL)resignFirstResponderInViewController:(UIViewController *)controller
{
    [G sharedInstance].firstResponderViewController = controller;
    
    return [self resignFirstResponder];
}

@end
