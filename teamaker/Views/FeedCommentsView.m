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
#import "TMLabel.h"

@interface FeedCommentsView()
@end

@implementation FeedCommentsView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRGBA:0xFFFFFFFF];
    }
    
    return self;
}

#pragma mark - UI

- (void)createView
{
    TMLabel *prevCommentLable;
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.comments.count; i++) {
        TMFeedComment *comment = self.comments[i];
        TMLabel *commentLabel = [self createCommentLabel:comment];
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

- (TMLabel *)createCommentLabel:(TMFeedComment *)comment
{
    TMLabel *commentLabel = [TMLabel new];
    commentLabel.numberOfLines = 0;
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableAttributedString *userString = [[NSMutableAttributedString alloc] initWithString:comment.user.name attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]}];
    
    NSAttributedString *replyFlagString;
    NSAttributedString *targetUserString;
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"：%@", comment.content] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    
    if (comment.targetUser) {
        replyFlagString = [[NSAttributedString alloc] initWithString:@" ▸ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        
        targetUserString = [[NSMutableAttributedString alloc] initWithString:comment.targetUser.name attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]}];
        
        [userString appendAttributedString:replyFlagString];
        [userString appendAttributedString:targetUserString];
        [userString appendAttributedString:commentString];
    } else {
        [userString appendAttributedString:commentString];
    }
    
    commentLabel.attributedText = userString;
    commentLabel.tag = comment.idValue;
    
    commentLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentDidTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [commentLabel addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commentDidLongPressed:)];
    [commentLabel addGestureRecognizer:longPressGesture];
    
    return commentLabel;
}

#pragma mark - actions

- (void)commentDidTapped:(UITapGestureRecognizer *)gesture
{
    TMFeedComment *comment = [TMFeedComment MR_findFirstByAttribute:@"id" withValue:[NSNumber numberWithLong:gesture.view.tag]];
    
    [self.delegate commentFeed:comment.feed targetUser:comment.user sender:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedTableViewCellShouldHideCommandsToolbar object:nil];
    
    // 背景变暗持续 0.2s 后变回来
    gesture.view.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    dispatch_after (dispatch_time (DISPATCH_TIME_NOW, (int64_t )(0.2 * NSEC_PER_SEC )), dispatch_get_main_queue (), ^{
        gesture.view.backgroundColor = gesture.view.superview.backgroundColor;
    });
}

- (void)commentDidLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        gesture.view.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        gesture.view.backgroundColor = gesture.view.superview.backgroundColor;
    }
}

#pragma mark - getters and setters

- (void)setComments:(NSArray *)comments
{
    _comments = comments;
    [self createView];
}

@end
