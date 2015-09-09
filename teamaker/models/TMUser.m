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

+ (TMUser *)findLoggedInUser
{
    NSNumber *loggedInUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserId"];

    return [TMUser MR_findFirstByAttribute:@"id" withValue:loggedInUserId];
}

+ (TMUser *)findLoggedInUserInContext:(NSManagedObjectContext *)context
{
    NSNumber *loggedInUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserId"];
        
    return [TMUser MR_findFirstByAttribute:@"id" withValue:loggedInUserId inContext:context];
}

- (NSArray *)findMyTeamsIdList
{
    NSMutableArray *myTeamsIdList = [NSMutableArray new];
    
    for (TMTeamUserInfo *teamInfo in self.teamsInfos) {
        [myTeamsIdList addObject:teamInfo.teamId];
    }
    
    return [myTeamsIdList copy];
}

- (NSArray *)findFeedsForMe
{
    NSArray *myTeamsIdList = [self findMyTeamsIdList];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId IN %@", myTeamsIdList];
    return [TMFeed MR_findAllSortedBy:@"createdAt" ascending:NO withPredicate:predicate];
}

- (BOOL)likedFeed:(TMFeed *)feed
{
    return [TMUserLikeFeed findByUserId:self.id feedId:feed.id] != nil;
}

- (NSArray *)findMyTeams
{
    NSArray *myTeamsIdList = [self findMyTeamsIdList];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id IN %@", myTeamsIdList];
    return [TMTeam MR_findAllSortedBy:@"id" ascending:NO withPredicate:predicate];
}

@end
