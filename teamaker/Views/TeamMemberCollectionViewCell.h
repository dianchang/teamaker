//
//  TeamMemberCollectionViewCell.h
//  teamaker
//
//  Created by hustlzp on 15/8/27.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMUser.h"

@interface TeamMemberCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *userAvatarView;
@property (strong, nonatomic) UILabel *userNameLabel;

- (void)updateDataWithUser:(TMUser *)user;

@end
