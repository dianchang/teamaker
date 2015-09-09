#import "_TMUserLikeFeed.h"

@interface TMUserLikeFeed : _TMUserLikeFeed {}

+ (TMUserLikeFeed *)findByUserId:(NSNumber *)userId feedId:(NSNumber *)feedId;

@end
