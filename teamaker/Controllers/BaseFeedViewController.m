//
//  FeedViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Masonry.h"
#import "AFNetworking.h"
#import "IonIcons.h"
#import "TMFeed.h"
#import "TMUser.h"
#import "TMFeedComment.h"
#import "MyProfileViewController.h"
#import "UIColor+Helper.h"
#import "UIImageView+AFNetworking.h"
#import "FeedTableViewCell.h"
#import "UserProfileViewController.h"
#import "TeamProfileViewController.h"
#import "Constants.h"
#import "ExternalLinkViewController.h"
#import "BaseFeedViewController.h"
#import "G.h"
#import "UIResponder+Helper.h"

typedef enum commentNextStateTypes
{
    COMMENT_NEXT_STATE_NONE,
    COMMENT_NEXT_STATE_SHOW,
    COMMENT_NEXT_STATE_HIDE,
} CommentNextState;

@interface BaseFeedViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UIView *commentBackdropView;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) UITextField *commentInputField;
@property (nonatomic) CommentNextState commentNextState;

@property (strong, nonatomic) TMFeed *feedForComment;
@property (strong, nonatomic) UIView *viewForComment;
@property (strong, nonatomic) TMUser *targetUserForComment;

@end

@implementation BaseFeedViewController

#pragma mark - view controller life cycle

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 表格
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    UITableView *tableView = [[UITableView alloc] init];
    tableViewController.view = tableView;
    [self addChildViewController:tableViewController];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor TMBackgroundColorGray];
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self createCommentView];
    
    // 注册reuseIdentifier
    [FeedTableViewCell registerClassForCellReuseIdentifierOnTableView:tableView];
    
    // 约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:TMFeedViewShouldReloadFeedsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableAndScrollToTop:) name:TMFeedViewShouldReloadFeedsAndScrollToTopNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMFeedViewShouldReloadFeedsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMFeedViewShouldReloadFeedsAndScrollToTopNotification object:nil];
    
    [self.commentView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedTableViewCellShouldHideCommandsToolbar object:nil];
}

#pragma mark - class var

+ (NSMutableDictionary *)cachedHeights
{
    static NSMutableDictionary *heights;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        heights = [NSMutableDictionary new];
    });
    
    return heights;
}

#pragma mark - FeedTableViewCellProtocol

// 跳转用户主页
- (void)redirectToUserProfile:(NSNumber *)userId
{
    UserProfileViewController *controller = [[UserProfileViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:controller animated:YES];
}

// 跳转团队主页
- (void)redirectToTeamProfile:(NSNumber *)teamId
{
    TeamProfileViewController *controller = [[TeamProfileViewController alloc] initWithTeamId:teamId];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)redirectToExternalLinkView:(NSNumber *)feedId
{
    // 需重载
}

// 星标feed
- (void)starFeed:(TMFeed *)feed
{
}

// 赞feed
- (void)likeFeed:(TMFeed *)feed
{
}

// 评论feed
- (void)commentFeed:(TMFeed *)feed targetUser:(TMUser *)targetUser sender:(UIView *)view
{
    self.feedForComment = feed;
    self.viewForComment = view;
    self.targetUserForComment = targetUser;
    
    if (targetUser) {
        self.commentInputField.placeholder = [NSString stringWithFormat:@"回复%@：", targetUser.name];
    } else {
        self.commentInputField.placeholder = @"评论";
    }
    
    [self showCommentView];
}

#pragma mark - comment view

- (UIView *)createCommentView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 背景
    UIView *commentBackdropView = [UIView new];
    
    UITapGestureRecognizer *tapGestureRecognizerForCommentBackdrop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCommentView)];
    tapGestureRecognizerForCommentBackdrop.numberOfTapsRequired = 1;
    [commentBackdropView addGestureRecognizer:tapGestureRecognizerForCommentBackdrop];
    
    UIPanGestureRecognizer *panGestureRecognizerForCommentBackdrop = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hideCommentView)];
    [commentBackdropView addGestureRecognizer:panGestureRecognizerForCommentBackdrop];
    
    self.commentBackdropView = commentBackdropView;
    
    UIView *commentView = [UIView new];
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]), 1);
    border.backgroundColor = [[UIColor colorWithRGBA:0xDDDDDDFF] CGColor];
    [commentView.layer addSublayer:border];
    commentView.backgroundColor = [UIColor colorWithRGBA:0xEEEEEEFF];
    [window addSubview:commentView];
    self.commentView = commentView;
    
    // 内层容器
    UIView *innerView = [UIView new];
    innerView.backgroundColor = [UIColor whiteColor];
    innerView.layer.cornerRadius = 5;
    innerView.layer.masksToBounds = YES;
    innerView.layer.borderColor=[[UIColor colorWithRGBA:0xDDDDDDFF] CGColor];
    innerView.layer.borderWidth= .5f;
    [commentView addSubview:innerView];
    
    // 输入框
    UITextField *inputField = [UITextField new];
    inputField.delegate = self;
    inputField.returnKeyType = UIReturnKeySend;
    self.commentInputField = inputField;
    inputField.backgroundColor = [UIColor whiteColor];
    inputField.placeholder = @"评论";
    [innerView addSubview:inputField];
    
    // 约束
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(window);
        make.top.equalTo(window.mas_bottom);
    }];
    
    [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(commentView).insets(UIEdgeInsetsMake(8, 10, 8, 10));
    }];
    
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(innerView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    return commentView;
}

/**
 *  显示评论框
 */
- (void)showCommentView
{
    self.commentNextState = COMMENT_NEXT_STATE_SHOW;
    [self.commentInputField becomeFirstResponderInViewController:self];
}

/**
 *  隐藏评论框
 */
- (void)hideCommentView
{
    self.commentNextState = COMMENT_NEXT_STATE_HIDE;
    [self.commentInputField resignFirstResponderInViewController:self];
}

// 键盘显示
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (![[G sharedInstance].firstResponderViewController isKindOfClass:[self class]]) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    if (self.commentNextState == COMMENT_NEXT_STATE_SHOW || self.commentNextState == COMMENT_NEXT_STATE_NONE) {
        [window addSubview:self.commentBackdropView];
        
        [self.commentBackdropView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(window);
            make.bottom.equalTo(self.commentView.mas_top);
        }];
        
        [window setNeedsLayout];
        [window layoutIfNeeded];
        
        [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(window);
            make.bottom.equalTo(window).offset(-keyboardHeight);
        }];
        
        [UIView animateWithDuration:animationDuration animations:^{
            [window setNeedsLayout];
            [window layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.commentNextState = COMMENT_NEXT_STATE_NONE;
        }];
    }
}

// 键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (![[G sharedInstance].firstResponderViewController isKindOfClass:[self class]]) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (self.commentNextState == COMMENT_NEXT_STATE_HIDE || self.commentNextState == COMMENT_NEXT_STATE_NONE) {
        [self.commentBackdropView removeFromSuperview];
        
        [self.commentView setNeedsLayout];
        [self.commentView layoutIfNeeded];
        
        [self.commentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(window);
            make.top.equalTo(window.mas_bottom);
        }];
        
        [UIView animateWithDuration:animationDuration animations:^{
            [self.commentView setNeedsLayout];
            [self.commentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.commentBackdropView removeFromSuperview];
            self.commentInputField.text = @"";
            self.commentNextState = COMMENT_NEXT_STATE_NONE;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!self.commentInputField.text.length) {
        return NO;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMUser *loggedInUser = [self.loggedInUser MR_inContext:localContext];
        TMFeedComment *comment = [TMFeedComment MR_createEntityInContext:localContext];
        TMFeed *feed = [self.feedForComment MR_inContext:localContext];
        
        TMUser *targetUser;
        
        if (self.targetUserForComment) {
            targetUser = [self.targetUserForComment MR_inContext:localContext];
        }
        
        comment.content = self.commentInputField.text;
        comment.createdAt = [NSDate date];
        comment.userId = loggedInUser.id;
        comment.user = loggedInUser;
        comment.feedId = feed.id;
        comment.feed = feed;
        
        if (targetUser) {
            comment.targetUserId = targetUser.id;
            comment.targetUser = targetUser;
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedViewShouldReloadFeedsNotification object:self userInfo:@{@"feed": self.feedForComment}];
        self.commentInputField.text = @"";
        [self hideCommentView];
    }];
    
    return YES;
}

# pragma mark - tableview dataSource and delegate

- (void)updateHeightForFeed:(TMFeed *)feed
{
    CGFloat height;
    height = [FeedTableViewCell calculateCellHeightWithFeed:feed] + 1;
    [[BaseFeedViewController cachedHeights] setObject:[NSNumber numberWithFloat:height] forKey:[feed.id stringValue]];
}

- (void)reloadTable:(NSNotification *)notification
{
    self.feeds = [self getFeedsData];
    [self.tableView reloadData];
    
    if (notification.userInfo) {
        TMFeed *feed = [notification.userInfo objectForKey:@"feed"];
        
        if (feed) {
            [self updateHeightForFeed:feed];
        }
    }
}

- (void)reloadTableAndScrollToTop:(NSNotification *)notification
{
    [self reloadTable:notification];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    });
}

- (NSArray *)getFeedsData
{
    // 需重载
    return @[];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feeds.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        TMFeed *feed = self.feeds[indexPath.row / 2];
        NSString *cellIdentifier = [FeedTableViewCell getResuseIdentifierByFeed:feed];
        FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.delegate = self;
        [cell updateCellWithFeed:feed];
        
        return cell;
    } else {
        UITableViewCell *cell = [UITableViewCell new];
        
        UIView *gapView = [UIView new];
        gapView.backgroundColor = [UIColor TMBackgroundColorGray];
        
        UIView *topBorderView = [UIView new];
        topBorderView.backgroundColor = [UIColor colorWithRGBA:0xD8D8D8FF];
        [gapView addSubview:topBorderView];
                                   
        [cell.contentView addSubview:gapView];
        
        [gapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        [topBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(gapView);
            make.height.equalTo(@0.5);
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if (indexPath.row % 2 == 0) {
        TMFeed *feed = self.feeds[indexPath.row / 2];
        NSNumber *cellHeight = [[BaseFeedViewController cachedHeights] objectForKey:[feed.id stringValue]];
        
        if (cellHeight) {
            return [cellHeight floatValue];
        }
        
        height = [FeedTableViewCell calculateCellHeightWithFeed:feed] + 1;
        
        [[BaseFeedViewController cachedHeights] setObject:[NSNumber numberWithFloat:height] forKey:[feed.id stringValue]];
    } else if (indexPath.row == self.feeds.count * 2 - 1) {
        height = 70.0;
    } else {
        height = 15.0;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    
    if (indexPath.row % 2 == 0) {
        TMFeed *feed = self.feeds[indexPath.row / 2];
        
        if ([feed.kind isEqualToString:@"punch"]) {
            cellHeight = 90.0;
        } else if ([feed.kind isEqualToString:@"image"]) {
            cellHeight = 280.0;
        } else if ([feed.kind isEqualToString:@"text"]) {
            cellHeight = 150.0;
        } else if ([feed.kind isEqualToString:@"share"]) {
            cellHeight = 150.0;
        }
    } else if (indexPath.row == self.feeds.count * 2 - 1) {
        cellHeight = 70.0;
    } else {
        cellHeight = 15.0;
    }
    
    return cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedTableViewCellShouldHideCommandsToolbar object:nil];
}

#pragma mark - getters and setters

- (TMUser *)loggedInUser
{
    if (!_loggedInUser) {
        _loggedInUser = [TMUser findLoggedInUser];
    }
    
    return _loggedInUser;
}

- (NSArray *)feeds
{
    if (!_feeds) {
        _feeds = [self getFeedsData];
    }
    
    return _feeds;
}

@end
