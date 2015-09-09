#import "_TMUser.h"
#import "TMFeed.h"

@interface TMUser : _TMUser {}

+ (TMUser *)getLoggedInUser;
+ (TMUser *)getLoggedInUserInContext:(NSManagedObjectContext *)context;
- (NSArray *)getMyTeamsIdList;
- (NSArray *)findMyTeams;
- (NSArray *)feedsForMe;
- (BOOL)likedFeed:(TMFeed *)feed;

@end
