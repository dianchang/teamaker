//
//  FeedCommentsView.h
//  teamaker
//
//  Created by hustlzp on 15/9/10.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTableViewCellProtocol.h"

@interface FeedCommentsView : UIView

@property (weak, nonatomic) id <FeedTableViewCellProtocol> delegate;
@property (strong, nonatomic) NSArray *comments;

@end
