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

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) NSUInteger currentPage;
@end

#define PAGE_COUNT 2

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadViewWithPage:0];
    [self loadViewWithPage:1];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageUp:) name:@"PageUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDown:) name:@"PageDown" object:nil];
}

-(void)pageUp:(NSNotification *)notification
{
    if(self.scrollView.contentOffset.y != 0){
        CGRect bounds = self.scrollView.bounds;
        bounds.origin.x = 0;
        bounds.origin.y = 0;
        [self.scrollView scrollRectToVisible:bounds animated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PageUp" object:nil];
    }
}

-(void)pageDown:(NSNotification *)notification
{
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = 0;
    bounds.origin.y = bounds.size.height;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageUp:) name:@"PageUp" object:nil];
}

- (NSMutableArray *)viewControllers
{
    if(!_viewControllers) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    self.scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height * PAGE_COUNT);
    
    for(int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *controller = self.viewControllers[i];
        frame.origin.x = 0;
        frame.origin.y = CGRectGetHeight(frame) * i;
        controller.view.frame = frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"haha");
}

@end
