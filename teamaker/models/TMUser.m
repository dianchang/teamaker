#import "TMUser.h"
#import "TMFeed.h"
#import "TMTeam.h"
#import "TMTeamUserInfo.h"
#import "TMUserLikeFeed.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMUser ()

// Private interface goes here.

@end

@implementation TMUser

+ (TMUser *)getLoggedInUser
{
    NSNumber *loggedInUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserId"];

    return [TMUser MR_findFirstByAttribute:@"id" withValue:loggedInUserId];
}

+ (TMUser *)getLoggedInUserInContext:(NSManagedObjectContext *)context
{
    NSNumber *loggedInUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserId"];
        
    return [TMUser MR_findFirstByAttribute:@"id" withValue:loggedInUserId inContext:context];
}

- (NSArray *)getMyTeamsIdList
{
    NSMutableArray *myTeamsIdList = [NSMutableArray new];
    
    for (TMTeamUserInfo *teamInfo in self.teamsInfos) {
        [myTeamsIdList addObject:teamInfo.teamId];
    }
    
    return [myTeamsIdList copy];
}

- (NSArray *)feedsForMe
{
    NSArray *myTeamsIdList = [self getMyTeamsIdList];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId IN %@", myTeamsIdList];
    return [TMFeed MR_findAllSortedBy:@"createdAt" ascending:NO withPredicate:predicate];
}

- (BOOL)likedFeed:(TMFeed *)feed
{
    return [TMUserLikeFeed findByUserId:self.id feedId:feed.id] != nil;
}

- (NSArray *)findMyTeams
{
    NSArray *myTeamsIdList = [self getMyTeamsIdList];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id IN %@", myTeamsIdList];
    return [TMTeam MR_findAllSortedBy:@"id" ascending:NO withPredicate:predicate];
}

@end
