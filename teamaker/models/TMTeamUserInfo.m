#import "TMTeamUserInfo.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMTeamUserInfo ()

// Private interface goes here.

@end

@implementation TMTeamUserInfo

// Custom logic goes here.

// 设置默认值
- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setPrimitiveCreatedAt:[NSDate date]];
}

/**
 *  获取某用户在某团队的信息
 *
 *  @param teamId <#teamId description#>
 *  @param userId <#userId description#>
 *
 *  @return <#return value description#>
 */
+ (TMTeamUserInfo *)findByTeamId:(NSNumber *)teamId userId:(NSNumber *)userId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId == %@) AND (teamId == %@)", userId, teamId];
    return [self MR_findFirstWithPredicate:predicate];
}

@end
