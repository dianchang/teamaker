//
//  PunchTableViewCell.m
//  teamaker
//
//  Created by hustlzp on 15/8/28.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "PunchTableViewCell.h"
#import "Masonry.h"

@interface PunchTableViewCell()

@property (strong, nonatomic) UILabel *punchLabel;

@end

@implementation PunchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *punchLabel = [UILabel new];
    punchLabel.font = [UIFont systemFontOfSize:20];
    self.punchLabel = punchLabel;
    [self.contentView addSubview:punchLabel];
    
    [punchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)updateCellWithPunch:(TMPunch *)punch
{
    self.punchLabel.text = punch.content;
}

- (void)deletePunch:(id)sender
{
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    UITableView *tableView = (UITableView *)view;

    id <UITableViewDelegate> delegate = tableView.delegate;
    if  ([delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [delegate tableView:tableView performAction:@selector(deletePunch:) forRowAtIndexPath:[tableView indexPathForCell:self] withSender:sender];
    }
}

@end
