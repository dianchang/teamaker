#import "_TMFeed.h"

@interface TMFeed : _TMFeed {}

+ (void)createTextFeed:(NSString *)text teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;

+ (void)createPunchFeed:(NSString *)punch teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;

+ (void)createImageFeed:(NSData *)imageData teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;

+ (void)createShareFeed:(NSString *)url title:(NSString *)title teamId:(NSNumber *)teamId completion:(void(^)(BOOL contextDidSave, NSError *error))completionBlock;

+ (NSArray *)findByUserId:(NSNumber *)userId;

+ (NSArray *)findByTeamId:(NSNumber *)teamId;

- (NSArray *)findLikers;

- (BOOL)isText;
- (BOOL)isImage;
- (BOOL)isPunch;
- (BOOL)isShare;

@end
