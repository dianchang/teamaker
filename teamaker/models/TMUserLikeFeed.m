#import "TMUserLikeFeed.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMUserLikeFeed ()

// Private interface goes here.

@end

@implementation TMUserLikeFeed

+ (TMUserLikeFeed *)findByUserId:(NSNumber *)userId feedId:(NSNumber *)feedId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId == %@) AND (feedId == %@)", userId, feedId];
    return [self MR_findFirstWithPredicate:predicate];
}

@end
