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
#import "TMTeam.h"
#import "TMFeed.h"
#import "ComposeViewControllerProtocol.h"
#import "UIColor+Helper.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Constants.h"

@interface ExternalLinkViewController() <ComposeViewControllerProtocol, UIWebViewDelegate>

@property (strong, nonatomic) NSArray *teams;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) TeamButtons *teamButtons;
@property (strong, nonatomic) UIView *backdropView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *pageTitle;
@property (strong, nonatomic) void (^feedCreationCompletionBlock)(void);

@end

@implementation ExternalLinkViewController

- (instancetype)initWithURL:(NSString *)url feedCreationCompletion:(void (^)(void))feedCreationCompletionBlock
{
    self = [super init];
    
    if (self) {
        self.url = url;
        self.feedCreationCompletionBlock = feedCreationCompletionBlock;
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
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *myProfileButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(preparePublish:)];
    self.navigationItem.rightBarButtonItem = myProfileButtonItem;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)preparePublish:(id)sender
{
    [self.teamButtons showWithDuration:.3 animation:nil completion:nil];
}

- (void)publish:(UIButton *)sender
{
    [TMFeed createShareFeed:self.url title:self.pageTitle teamId:[NSNumber numberWithLong:sender.tag] completion:^(BOOL contextDidSave, NSError *error) {

        if (self.feedCreationCompletionBlock) {
            self.feedCreationCompletionBlock();
        }
    }];
}

- (void)cancelPublish:(UIButton *)sender
{
    [self hideTeamButtons];
}

- (void)hideTeamButtons
{
    [self.teamButtons hideWithDuration:.3 animation:nil completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - getters and setters

- (NSArray *)teams
{
    if (!_teams) {
        _teams = [TMTeam MR_findAll];
    }
    return _teams;
}

- (TeamButtons *)teamButtons
{
    if (!_teamButtons) {
        _teamButtons = [[TeamButtons alloc] initWithTeams:self.teams backgroundFaded:YES];
        _teamButtons.delegate = self;
    }
    
    return _teamButtons;
}

@end
