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
#import "Masonry.h"
#import "Constants.h"
#import "G.h"

@interface ComposeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) BOOL hasSendedResetAndPrepareLayoutMessage;
@property (nonatomic) BOOL hasSetup;

@end

#define PAGE_COUNT 3

@implementation ComposeViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIPageControl *pageControl = [UIPageControl new];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 约束
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(-5);
    }];
}

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
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSubviewsLayout) name:TMHorizonalScrollShouldResetSubviewsLayoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareSubviewsLayout) name:TMHorizonalScrollShouldPrepareSubviewsLayoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showComposePager) name:TMHorizonalScrollViewShouldShowPagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideComposePager) name:TMHorizonalScrollViewShouldHidePagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidPageDown) name:TMVerticalScrollViewDidPageDownNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidPageUp) name:TMVerticalScrollViewDidPageUpNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMHorizonalScrollShouldResetSubviewsLayoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMHorizonalScrollShouldPrepareSubviewsLayoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMHorizonalScrollViewShouldShowPagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMHorizonalScrollViewShouldHidePagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMVerticalScrollViewDidPageDownNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMVerticalScrollViewDidPageUpNotification object:nil];
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
    
    // 初始化翻页到打卡页
    if (!self.hasSetup) {
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.bounds.size.width * 1, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:NO];
        self.pageControl.currentPage = 1;
        self.hasSetup = YES;
    }
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
            controller = [[TextViewController alloc] init];
            break;
        case 1:
            controller = [[PunchViewController alloc] init];
            break;
        case 2: {
            CaptureViewController *captureViewController = [[CaptureViewController alloc] init];
            controller = [[UINavigationController alloc] initWithRootViewController:captureViewController];
            break;
        }
    }
    
    [self addChildViewController:controller];
    [self.viewControllers insertObject:controller atIndex:page];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

/**
 *  向下翻页结束
 */
- (void)scrollViewDidPageDown
{
    if (self.pageControl.currentPage == 1) {
        [self didPageToPunchComposeView];
    } else {
        [self didPageToOtherComposeView];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TMCameraShouldStartNotification object:nil];
}

/**
 *  向上翻页结束
 */
- (void)scrollViewDidPageUp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TMCameraShouldStopNotification object:nil];
}

- (void)didPageToOtherComposeView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewDidPageToOtherComposeViewNotification object:nil];
}

- (void)didPageToPunchComposeView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TMHorizonalScrollViewDidPageToPunchComposeViewNotification object:nil];
}

// 翻页结束后，联动pageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.hasSetup) {
        return;
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageControl.currentPage = page;
    self.hasSendedResetAndPrepareLayoutMessage = NO;
    
    if (page == 1) {
        [self didPageToPunchComposeView];
    } else {
        [self didPageToOtherComposeView];
    }
    
    if (page == 0) {
        [G sharedInstance].horizonalPosition = HORIZONAL_POSITION_TEXT;
    }  else if (page == 1) {
        [G sharedInstance].horizonalPosition = HORIZONAL_POSITION_PUNCH;
    } else {
        [G sharedInstance].horizonalPosition = HORIZONAL_POSITION_CAPTURE;
    }
}

// 翻到其他页时，对当前页进行界面重置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.hasSetup) {
        return;
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.pageControl.currentPage != page && !self.hasSendedResetAndPrepareLayoutMessage) {
        UIViewController *currentController = [self getComposeViewControllerAtPage:self.pageControl.currentPage];
//        NSLog(@"Reset - %ld", (long)self.pageControl.currentPage);
        if ([currentController respondsToSelector:@selector(resetLayout)]) {
            [currentController performSelector:@selector(resetLayout) withObject:nil];
            self.hasSendedResetAndPrepareLayoutMessage = YES;

        }
        
//        NSLog(@"Prepare - %lu", (unsigned long)page);
        UIViewController *nextController = [self getComposeViewControllerAtPage:page];
        if ([nextController respondsToSelector:@selector(prepareLayout)]) {
            [nextController performSelector:@selector(prepareLayout) withObject:nil];

        }
    }
    

}

/**
 *  重置compose view controller界面
 */
- (void)resetSubviewsLayout
{
    UIViewController *controller = [self getComposeViewControllerAtPage:self.pageControl.currentPage];
    if ([controller respondsToSelector:@selector(resetLayout)]) {
        [controller performSelector:@selector(resetLayout) withObject:nil];
    }
}

/**
 *  准备compose view controller界面
 */
- (void)prepareSubviewsLayout
{
    UIViewController *controller = [self getComposeViewControllerAtPage:self.pageControl.currentPage];
    if ([controller respondsToSelector:@selector(prepareLayout)]) {
        [controller performSelector:@selector(prepareLayout) withObject:nil];
    }
}

/**
 *  获取某页的compose view controller
 *
 *  @return
 */
- (UIViewController *)getComposeViewControllerAtPage:(NSInteger)page
{
    UIViewController *controller = self.viewControllers[page];
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [[(UINavigationController *)controller viewControllers] firstObject];
    }
    
    return controller;
}

- (void)showComposePager
{
    self.pageControl.hidden = NO;
}

- (void)hideComposePager
{
    self.pageControl.hidden = YES;
}

@end
