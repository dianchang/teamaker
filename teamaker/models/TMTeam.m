#import "TMTeam.h"
#import "TMFeed.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMTeam ()

// Private interface goes here.

@end

@implementation TMTeam

/**
 *  获取最大的id值
 *
 *  @return <#return value description#>
 */
+ (int)getMaxIdValue
{
    NSFetchRequest *request = [TMTeam MR_requestAllSortedBy:@"id" ascending:NO withPredicate:nil];
    request.fetchLimit = 1;
    TMTeam *team = [[TMTeam MR_executeFetchRequest:request] firstObject];
    
    if (team) {
        return team.idValue;
    } else {
        return 0;
    }
}

/**
 *  获取星标feeds
 *
 *  @return <#return value description#>
 */
- (NSArray *)findStarredFeeds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId == %@) AND (starred == 1)", self.id];
    return [TMFeed MR_findAllSortedBy:@"createdAt" ascending:NO withPredicate:predicate];
}

@end
