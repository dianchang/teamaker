#import "TMFeed.h"
#import "TMUser.h"
#import "TMTeam.h"
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
        TMUser *loggedInUser = [TMUser getLoggedInUserInContext:localContext];
        TMFeed *feed = [TMFeed MR_createEntityInContext:localContext];
        feed.kind = @"text";
        feed.userId = loggedInUser.id;
        feed.user = loggedInUser;
        feed.teamId = teamId;
        feed.team = [TMTeam MR_findFirstByAttribute:@"id" withValue:teamId inContext:localContext];
        feed.text = text;
        feed.createdAt = [NSDate date];
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
        TMUser *loggedInUser = [TMUser getLoggedInUserInContext:localContext];
        TMFeed *feed = [TMFeed MR_createEntityInContext:localContext];
        feed.kind = @"punch";
        feed.userId = loggedInUser.id;
        feed.user = loggedInUser;
        feed.teamId = teamId;
        feed.team = [TMTeam MR_findFirstByAttribute:@"id" withValue:teamId inContext:localContext];
        feed.punch = punch;
        feed.createdAt = [NSDate date];
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
        TMUser *loggedInUser = [TMUser getLoggedInUserInContext:localContext];
        TMFeed *feed = [TMFeed MR_createEntityInContext:localContext];
        feed.kind = @"image";
        feed.userId = loggedInUser.id;
        feed.user = loggedInUser;
        feed.teamId = teamId;
        feed.team = [TMTeam MR_findFirstByAttribute:@"id" withValue:teamId inContext:localContext];
        feed.image = imageData;
        feed.createdAt = [NSDate date];
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
        TMUser *loggedInUser = [TMUser getLoggedInUserInContext:localContext];
        TMFeed *feed = [TMFeed MR_createEntityInContext:localContext];
        feed.kind = @"share";
        feed.userId = loggedInUser.id;
        feed.user = loggedInUser;
        feed.teamId = teamId;
        feed.team = [TMTeam MR_findFirstByAttribute:@"id" withValue:teamId inContext:localContext];
        feed.shareUrl = url;
        feed.shareTitle = title;
        feed.createdAt = [NSDate date];
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (completionBlock) {
            completionBlock(contextDidSave, error);
        }
    }];
}

@end
