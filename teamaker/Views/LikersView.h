//
//  LikersView.h
//  teamaker
//
//  Created by hustlzp on 15/9/9.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableViewCellProtocol.h"

@interface LikersView : UIView

@property (strong, nonatomic) NSArray *likers;
@property (weak, nonatomic) id <FeedTableViewCellProtocol> delegate;

- (void)addLiker:(NSNumber *)likerId;
- (void)removeLiker:(NSNumber *)likerId;

@end
