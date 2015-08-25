#import "_TMFeed.h"

@interface TMFeed : _TMFeed {}

+ (void)createTextFeed:(NSString *)text teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;

@end
