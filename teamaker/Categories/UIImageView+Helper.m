//
//  UIImageView+Helper.m
//  teamaker
//
//  Created by hustlzp on 15/9/8.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)

- (UIImageView *)initWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:image];
}

@end
