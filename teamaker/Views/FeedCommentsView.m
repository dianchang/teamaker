//
//  FeedCommentsView.m
//  teamaker
//
//  Created by hustlzp on 15/9/10.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "FeedCommentsView.h"
#import "TMFeedComment.h"
#import "TMUser.h"
#import "Masonry.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Constants.h"
#import "UIColor+Helper.h"

@implementation FeedCommentsView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRGBA:0xF5FFFAFF];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            [(UILabel *)subview setPreferredMaxLayoutWidth:CGRectGetWidth(subview.frame)];
        }
    }
}

#pragma mark - UI

- (void)createView
{
    UILabel *prevCommentLable;
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.comments.count; i++) {
        TMFeedComment *comment = self.comments[i];
        UILabel *commentLabel = [self createCommentLabel:comment];
        [self addSubview:commentLabel];
        
        // 约束
        [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
        }];
        
        if (i == 0) {
            [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
            }];
        } else {
            [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(prevCommentLable.mas_bottom).offset(5);
            }];
        }
        
        if (i == self.comments.count - 1) {
            [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
            }];
        }
        
        prevCommentLable = commentLabel;
    }
}

- (UILabel *)createCommentLabel:(TMFeedComment *)comment
{
    UILabel *commentLable = [UILabel new];
    commentLable.numberOfLines = 0;
    commentLable.lineBreakMode = NSLineBreakByWordWrapping;
    commentLable.font = [UIFont systemFontOfSize:14];
    commentLable.text = [NSString stringWithFormat:@"%@：%@", comment.user.name, comment.content];
    commentLable.tag = comment.idValue;
    
    commentLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyComment:)];
    tapGesture.numberOfTapsRequired = 1;
    [commentLable addGestureRecognizer:tapGesture];
    
    return commentLable;
}

#pragma mark - actions

- (void)replyComment:(UITapGestureRecognizer *)gesture
{
    TMFeedComment *comment = [TMFeedComment MR_findFirstByAttribute:@"id" withValue:[NSNumber numberWithLong:gesture.view.tag]];
    
    [self.delegate commentFeed:comment.feed targetUser:comment.user sender:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedTableViewCellShouldHideCommandsToolbar object:nil];
    
    // 背景变暗持续 0.2s 后变回来
    gesture.view.backgroundColor = [UIColor colorWithRGBA:0xD1EEEEFF];
    dispatch_after (dispatch_time (DISPATCH_TIME_NOW, (int64_t )(0.2 * NSEC_PER_SEC )), dispatch_get_main_queue (), ^{
        gesture.view.backgroundColor = gesture.view.superview.backgroundColor;
    });
}

#pragma mark - getters and setters

- (void)setComments:(NSArray *)comments
{
    _comments = comments;
    [self createView];
}

@end
