#import "_TMFeedComment.h"
#import "TMFeed.h"
#import "TMUser.h"

@interface TMFeedComment : _TMFeedComment {}

+ (void)createFeedComment:(NSString *)content feed:(TMFeed *)feed user:(TMUser *)user targetUser:(TMUser *)targetUser completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;

@end
