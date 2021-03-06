#import "TMFeed.h"
#import "TMUser.h"
#import "TMTeam.h"
#import "TMUserLikeFeed.h"
#import "TMFeedComment.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMFeed ()

// Private interface goes here.

@end

@implementation TMFeed

/**
 *  存储文本类feed
 *
 *  @param text            <#text description#>
 *  @param teamId          <#teamId description#>
 *  @param completionBlock <#completionBlock description#>
 */
+ (void)createTextFeed:(NSString *)text teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMFeed *feed = [TMFeed createFeedWithTeamId:teamId inContext:localContext];
        feed.kind = @"text";
        feed.text = text;
    } completion:^(BOOL contextDidSave, NSError *error) {
        completionBlock(contextDidSave, error);
    }];
}

/**
 *  存储打卡类feed
 *
 *  @param punch           <#punch description#>
 *  @param teamId          <#teamId description#>
 *  @param completionBlock <#completionBlock description#>
 */
+ (void)createPunchFeed:(NSString *)punch teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMFeed *feed = [TMFeed createFeedWithTeamId:teamId inContext:localContext];
        feed.kind = @"punch";
        feed.punch = punch;
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(contextDidSave, error);
        }
    }];
}

/**
 *  存储图片类feed
 *
 *  @param imageData       <#imageData description#>
 *  @param teamId          <#teamId description#>
 *  @param completionBlock <#completionBlock description#>
 */
+ (void)createImageFeed:(NSData *)imageData teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMFeed *feed = [TMFeed createFeedWithTeamId:teamId inContext:localContext];
        feed.kind = @"image";
        feed.image = imageData;
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(contextDidSave, error);
        }
    }];
}

/**
 *  存储分享类feed
 *
 *  @param url             <#url description#>
 *  @param title           <#title description#>
 *  @param teamId          <#teamId description#>
 *  @param completionBlock <#completionBlock description#>
 */
+ (void)createShareFeed:(NSString *)url title:(NSString *)title teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        TMFeed *feed = [TMFeed createFeedWithTeamId:teamId inContext:localContext];
        feed.kind = @"share";
        feed.shareUrl = url;
        feed.shareTitle = title;
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(contextDidSave, error);
        }
    }];
}

/**
 *  创建feed
 *
 *  @param teamId  <#teamId description#>
 *  @param context <#context description#>
 *
 *  @return <#return value description#>
 */
+ (TMFeed *)createFeedWithTeamId:(NSNumber *)teamId inContext:(NSManagedObjectContext *)context
{
    TMUser *loggedInUser = [TMUser findLoggedInUserInContext:context];
    TMFeed *feed = [TMFeed MR_createEntityInContext:context];
    feed.idValue = [TMFeed getMaxIdValue] + 1;
    feed.userId = loggedInUser.id;
    feed.user = loggedInUser;
    feed.teamId = teamId;
    feed.team = [TMTeam MR_findFirstByAttribute:@"id" withValue:teamId inContext:context];
    feed.createdAt = [NSDate date];
    
    return feed;
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
    TMFeed *feed = [[TMFeed MR_executeFetchRequest:request] firstObject];
    
    if (feed) {
        return feed.idValue;
    } else {
        return 0;
    }
}

/**
 *  获取某user的feeds
 *
 *  @param userId <#userId description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)findByUserId:(NSNumber *)userId
{
    return [self MR_findByAttribute:@"userId" withValue:userId andOrderBy:@"createdAt" ascending:NO];
}

/**
 *  获取某team的feeds
 *
 *  @param teamId <#teamId description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)findByTeamId:(NSNumber *)teamId
{
    return [self MR_findByAttribute:@"teamId" withValue:teamId andOrderBy:@"createdAt" ascending:NO];
}

- (BOOL)isText
{
    return [self.kind isEqualToString:@"text"];
}

- (BOOL)isPunch
{
    return [self.kind isEqualToString:@"punch"];
}

- (BOOL)isShare
{
    return [self.kind isEqualToString:@"share"];
}

- (BOOL)isImage
{
    return [self.kind isEqualToString:@"image"];
}

- (NSArray *)findLikers
{
    return [TMUserLikeFeed MR_findByAttribute:@"feedId" withValue:self.id andOrderBy:@"createdAt" ascending:NO];
}

- (NSArray *)findComments
{
    return [TMFeedComment MR_findByAttribute:@"feedId" withValue:self.id andOrderBy:@"createdAt" ascending:YES];
}

@end
