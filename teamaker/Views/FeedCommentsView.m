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

@implementation FeedCommentsView


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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            [(UILabel *)subview setPreferredMaxLayoutWidth:CGRectGetWidth(subview.frame)];
        }
    }
}

- (UILabel *)createCommentLabel:(TMFeedComment *)comment
{
    UILabel *commentLable = [UILabel new];
    commentLable.numberOfLines = 0;
    commentLable.lineBreakMode = NSLineBreakByWordWrapping;
    commentLable.font = [UIFont systemFontOfSize:12];
    commentLable.text = [NSString stringWithFormat:@"%@：%@", comment.user.name, comment.content];
    
    return commentLable;
}

#pragma mark - getters and setters

- (void)setComments:(NSArray *)comments
{
    _comments = comments;
    [self createView];
}

@end
