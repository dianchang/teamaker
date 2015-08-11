//
//  ViewController.m
//  teamaker
//
//  Created by hustlzp on 15/8/11.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "ViewController.h"
#import "PunchViewController.h"
#import "CaptureViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
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
    
    self.scrollView.contentSize = CGSizeMake(frame.size.width * PAGE_COUNT, frame.size.height);
    
    for(int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *controller = self.viewControllers[i];
        frame.origin.x = CGRectGetWidth(frame) * i;
        frame.origin.y = 0;
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
            controller = [[PunchViewController alloc] init];
            break;
        case 1:
            controller = [[CaptureViewController alloc] init];
            break;
    }
    
    [self addChildViewController:controller];
    [self.viewControllers insertObject:controller atIndex:page];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

@end
