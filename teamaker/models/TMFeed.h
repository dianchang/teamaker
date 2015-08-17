//
//  TMFeed.h
//  teamaker
//
//  Created by hustlzp on 15/8/17.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMFeed : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *position;

@end
