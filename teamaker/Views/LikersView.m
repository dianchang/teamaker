//
//  LikersView.m
//  teamaker
//
//  Created by hustlzp on 15/9/9.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LikersView.h"
#import "TMUserLikeFeed.h"
#import "TMUser.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"

@interface LikersView ()

@property (nonatomic) NSInteger rowsNumber;
@property (nonatomic) NSInteger avatarsNumberPerLine;
@property (nonatomic, strong) MASConstraint *heightConstraint;

@end

static const NSInteger avatarBorder = 20;
static const NSInteger verticalGap = 8;
static const NSInteger horizonalGap = 8;

@implementation LikersView

- (void)setLikers:(NSArray *)likers
{
    _likers = likers;
    [self createView];
}

- (void)createView
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.likers.count; i++) {
        TMUserLikeFeed *likeFeed = self.likers[i];
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, avatarBorder, avatarBorder)];
        avatarView.layer.cornerRadius = avatarBorder / 2;
        avatarView.layer.masksToBounds = YES;
        [avatarView setImageWithURL:[NSURL URLWithString:likeFeed.user.avatar]];
        [self addSubview:avatarView];
    }
}

- (void)layoutSubviews
{
    self.avatarsNumberPerLine = (self.frame.size.width + horizonalGap) / (avatarBorder + horizonalGap);
    self.rowsNumber = ceil(self.likers.count / (CGFloat)self.avatarsNumberPerLine);
    
    if (self.heightConstraint) {
        [self.heightConstraint uninstall];
    }
    
    if (self.rowsNumber == 0) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.heightConstraint = make.height.equalTo(@0);
        }];
    } else {
        for (int i = 0; i < self.subviews.count; i++) {
            NSInteger col = i % self.avatarsNumberPerLine;
            NSInteger row = i / self.avatarsNumberPerLine;
            UIImageView *avatarView = self.subviews[i];
            CGRect frame = avatarView.frame;
            frame.origin.x = col * (avatarBorder + horizonalGap);
            frame.origin.y = row * (avatarBorder + verticalGap);
            avatarView.frame = frame;
        }
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.heightConstraint = make.height.equalTo([NSNumber numberWithLong:avatarBorder * self.rowsNumber + verticalGap * (self.rowsNumber - 1)]);
        }];
    }
    
    [super layoutSubviews];
}

- (void)addLiker:(NSNumber *)likerId
{

}

- (void)removeLiker:(NSNumber *)likerId
{

}

@end
