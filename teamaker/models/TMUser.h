#import "_TMUser.h"
#import "TMFeed.h"

@interface TMUser : _TMUser {}

+ (TMUser *)findLoggedInUser;
+ (TMUser *)findLoggedInUserInContext:(NSManagedObjectContext *)context;
- (NSArray *)findMyTeamsIdList;
- (NSArray *)findMyTeams;
- (NSArray *)findFeedsForMe;
- (BOOL)likedFeed:(TMFeed *)feed;

@end
