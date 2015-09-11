#import "TMFeedComment.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMFeedComment ()

// Private interface goes here.

@end

@implementation TMFeedComment

+ (void)createFeedComment:(NSString *)content feed:(TMFeed *)feed user:(TMUser *)user targetUser:(TMUser *)targetUser completion:(void (^)(BOOL, NSError *))completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMUser *_user = [user MR_inContext:localContext];
        TMFeedComment *comment = [TMFeedComment MR_createEntityInContext:localContext];
        TMFeed *_feed = [feed MR_inContext:localContext];
        
        TMUser *_targetUser;
        
        if (targetUser) {
            _targetUser = [targetUser MR_inContext:localContext];
        }
        
        comment.idValue = [self getMaxIdValue] + 1;
        comment.content = content;
        comment.createdAt = [NSDate date];
        comment.userId = _user.id;
        comment.user = _user;
        comment.feedId = _feed.id;
        comment.feed = _feed;
        
        if (targetUser) {
            comment.targetUserId = _targetUser.id;
            comment.targetUser = _targetUser;
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(contextDidSave, error);
        }
    }];
}

/**
 *  获取最大的id值
 *
 *  @return <#return value description#>
 */
+ (int)getMaxIdValue
{
    NSFetchRequest *request = [TMFeed MR_requestAllSortedBy:@"id" ascending:NO withPredicate:nil];
    request.fetchLimit = 1;
    TMFeed *feed = [[TMFeedComment MR_executeFetchRequest:request] firstObject];
    
    if (feed) {
        return feed.idValue;
    } else {
        return 0;
    }
}

@end
