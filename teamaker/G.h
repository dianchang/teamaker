//
//  G.h
//  teamaker
//
//  Created by hustlzp on 15/9/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum verticalPositionEnum
{
    VERTICAL_POSITION_FEED,
    VERTICAL_POSITION_COMPOSE,
} VerticalPosition;

typedef enum horizonalPositionEnum
{
    HORIZONAL_POSITION_TEXT,
    HORIZONAL_POSITION_PUNCH,
    HORIZONAL_POSITION_CAPTURE,
} HorizonalPosition;

@interface G : NSObject

+ (G *)sharedInstance;

@property (nonatomic) VerticalPosition verticalPosition;
@property (nonatomic) HorizonalPosition horizonalPosition;
@property (strong, nonatomic) UIViewController *firstResponderViewController;

@end
