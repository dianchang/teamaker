//
//  ViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "ViewController.h"
#import "FeedViewController.h"
#import "ComposeViewController.h"
#import "ScrollDirection.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) BOOL hasSendedResetMessage;
@property (nonatomic) CGFloat lastContentOffset;
@end

#define PAGE_COUNT 2

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int i = 0; i < PAGE_COUNT; i++) {
        [self loadViewWithPage:i];
    }
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageUp:) name:@"PageUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDown:) name:@"PageDown" object:nil];
}

// 向上翻页
-(void)pageUp:(NSNotification *)notification
{
    if(self.scrollView.contentOffset.y != 0){
        CGRect bounds = self.scrollView.bounds;
        bounds.origin.x = 0;
        bounds.origin.y = 0;
        [self.scrollView scrollRectToVisible:bounds animated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PageUp" object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetSubviewsLayout" object:self];
}

// 向下翻页
-(void)pageDown:(NSNotification *)notification
{
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = 0;
    bounds.origin.y = bounds.size.height;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"prepareSubviewsLayout" object:self];
}

// 翻页中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight = CGRectGetHeight(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    self.lastContentOffset = scrollView.contentOffset.y;
    
    // 往上滑动、并且滑动超过一半时，触发reset效果
    if (scrollDirection == ScrollDirectionUp && page == 0 && !self.hasSendedResetMessage) {
        self.hasSendedResetMessage = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetSubviewsLayout" object:self];
    }
}

// 手动翻页结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self didEndScrolling];
}

// 程序翻页结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self didEndScrolling];
}

// 翻页结束
- (void)didEndScrolling
{
    CGFloat pageHeight = CGRectGetHeight(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    if (page == 0) {
        self.hasSendedResetMessage = YES;
        self.scrollView.scrollEnabled = NO;
    } else {
        self.hasSendedResetMessage = NO;
        self.scrollView.scrollEnabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageUp:) name:@"PageUp" object:nil];
    }
}

- (NSMutableArray *)viewControllers
{
    if(!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

#define STATUS_BAR_HEIGHT 20

// 对每一页的view进行布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.scrollView.bounds;
    NSInteger width = frame.size.width;
    NSInteger height = frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(width, height * self.viewControllers.count);
    
    for(int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *controller = self.viewControllers[i];
        controller.view.frame = CGRectMake(0, height * i, width, height);
    }
}

// 加载每一页的Controller
- (void)loadViewWithPage:(NSUInteger)page
{
    UIViewController *controller;
    
    switch (page) {
        case 0:
            controller = [[FeedViewController alloc] init];
            break;
        case 1:
            controller = [[ComposeViewController alloc] init];
            break;
    }
    
    [self addChildViewController:controller];
    [self.viewControllers insertObject:controller atIndex:page];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

@end
