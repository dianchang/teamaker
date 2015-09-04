//
//  ExternalLinkViewController.m
//  teamaker
//
//  Created by hustlzp on 15/9/4.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "ExternalLinkViewController.h"
#import "TeamButtons.h"
#import "Masonry.h"
#import "ComposeViewControllerProtocol.h"

@interface ExternalLinkViewController() <ComposeViewControllerProtocol, UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic) NSString *url;

@end


@implementation ExternalLinkViewController

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    
    if (self) {
        self.url = url;
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    UIWebView *webView = [UIWebView new];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIActivityIndicatorView *loadingSpinner = [UIActivityIndicatorView new];
    loadingSpinner.color = [UIColor grayColor];
    [webView addSubview:loadingSpinner];
    self.loadingSpinner = loadingSpinner;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [loadingSpinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(webView);
        make.top.equalTo(webView).offset(60);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *myProfileButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(preparePublish:)];
    self.navigationItem.rightBarButtonItem = myProfileButtonItem;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.loadingSpinner startAnimating];
}

- (void)preparePublish:(id)sender
{

}

- (void)publish:(UIButton *)sender
{

}

- (void)cancelPublish:(UIButton *)sender
{

}

- (void)resetLayout
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingSpinner stopAnimating];
}

@end
