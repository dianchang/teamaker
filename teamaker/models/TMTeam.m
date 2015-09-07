#import "TMTeam.h"
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

@end
