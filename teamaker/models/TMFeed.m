#import "TMFeed.h"
#import "TMUser.h"
#import "TMTeam.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMFeed ()

// Private interface goes here.

@end

@implementation TMFeed

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

+ (void)createPunchFeed:(NSString *)punch teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;
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
        completionBlock(contextDidSave, error);
    }];
}

@end
