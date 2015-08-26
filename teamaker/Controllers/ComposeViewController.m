//
//  ComposeViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "ComposeViewController.h"
#import "PunchViewController.h"
#import "CaptureViewController.h"
#import "TextViewController.h"
#import "LocationViewController.h"
#import "ComposeViewControllerProtocol.h"

@interface ComposeViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) BOOL hasSendedResetLayoutMessage;
@end

#define PAGE_COUNT 4

@implementation ComposeViewController

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
    
    self.pageControl.numberOfPages = PAGE_COUNT;
    self.pageControl.currentPage = 2;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSubviewsLayout) name:@"resetSubviewsLayout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareSubviewsLayout) name:@"prepareSubviewsLayout" object:nil];
}

- (NSMutableArray *)viewControllers
{
    if(!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

#define STATUS_BAR_HEIGHT 20

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.bounds.size.width * 2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:NO];
}

// 初始化各页大小
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = [self.scrollView bounds];
    NSInteger width = frame.size.width;
    NSInteger height = frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(width * PAGE_COUNT, height);
    
    for (int i = 0; i < PAGE_COUNT; i++) {
        UIViewController *controller = self.viewControllers[i];
        controller.view.frame = CGRectMake(width * i, 0, width, height);
    }
}

// 加载每一页的controller
- (void)loadViewWithPage:(NSUInteger)page
{
    UIViewController *controller;
    
    switch (page) {
        case 0:
            controller = [[LocationViewController alloc] init];
            break;
        case 1:
            controller = [[TextViewController alloc] init];
            break;
        case 2:
            controller = [[PunchViewController alloc] init];
            break;
        case 3:
            controller = [[CaptureViewController alloc] init];
            break;
    }
    
    [self addChildViewController:controller];
    [self.viewControllers insertObject:controller atIndex:page];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

// 翻页结束后，联动pageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageControl.currentPage = page;
    self.hasSendedResetLayoutMessage = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.pageControl.currentPage != page && !self.hasSendedResetLayoutMessage) {
        UIViewController *controller = self.viewControllers[self.pageControl.currentPage];
        if ([controller respondsToSelector:@selector(resetLayout)]) {
            [controller performSelector:@selector(resetLayout) withObject:nil];
            self.hasSendedResetLayoutMessage = YES;
        }
    }

    UIViewController *currentController = self.viewControllers[page];
    if ([currentController respondsToSelector:@selector(prepareLayout)]) {
        [currentController performSelector:@selector(prepareLayout) withObject:nil];
    }
}

- (void)resetSubviewsLayout
{
    UIViewController *controller = self.viewControllers[self.pageControl.currentPage];
    if ([controller respondsToSelector:@selector(resetLayout)]) {
        [controller performSelector:@selector(resetLayout) withObject:nil];
    }
}

- (void)prepareSubviewsLayout
{
    UIViewController *controller = self.viewControllers[self.pageControl.currentPage];
    if ([controller respondsToSelector:@selector(prepareLayout)]) {
        [controller performSelector:@selector(prepareLayout) withObject:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetLayout" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"prepareLayout" object:nil];
}

@end