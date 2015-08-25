#import "TMUser.h"
#import <MagicalRecord/MagicalRecord.h>

@interface TMUser ()

// Private interface goes here.

@end

@implementation TMUser

+ (TMUser *)getLoggedInUser
{
    NSNumber *loggedInUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserId"];
    
    return [TMUser MR_findFirstByAttribute:@"id" withValue:loggedInUserId];
}

@end
