//
//  TeamStarredFeedsViewController.m
//  teamaker
//
//  Created by hustlzp on 15/9/8.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#import "TeamStarredFeedsViewController.h"
#import "TMTeam.h"
#import "ExternalLinkViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Constants.h"

@interface TeamStarredFeedsViewController ()

@property (strong, nonatomic) NSNumber *teamId;
@property (strong, nonatomic) TMTeam *team;

@end

@implementation TeamStarredFeedsViewController

- (instancetype)initWithTeamId:(NSNumber *)teamId
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.teamId = teamId;
    
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"星标内容";
}

#pragma mark - infreit from super class

- (NSArray *)getFeedsData
{
    return [self.team findStarredFeeds];
}

#pragma mark - FeedTableViewCellProtocol

- (void)redirectToExternalLinkView:(NSNumber *)feedId
{
    TMFeed *feed = [TMFeed MR_findFirstByAttribute:@"id" withValue:feedId];
    ExternalLinkViewController *controller = [[ExternalLinkViewController alloc] initWithURL:feed.shareUrl feedCreationCompletion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:TMFeedViewShouldReloadFeedsAndScrollToTopNotification object:nil];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - getters and setters

- (TMTeam *)team
{
    if(!_team) {
        _team = [TMTeam MR_findFirstByAttribute:@"id" withValue:self.teamId];
    }
    
    return _team;
}

@end
