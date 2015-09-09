// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUserLikeFeed.h instead.

#import <CoreData/CoreData.h>

extern const struct TMUserLikeFeedAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *feedId;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *userId;
} TMUserLikeFeedAttributes;

extern const struct TMUserLikeFeedRelationships {
	__unsafe_unretained NSString *feed;
	__unsafe_unretained NSString *user;
} TMUserLikeFeedRelationships;

@class TMFeed;
@class TMUser;

@interface TMUserLikeFeedID : NSManagedObjectID {}
@end

@interface _TMUserLikeFeed : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMUserLikeFeedID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* feedId;

@property (atomic) int32_t feedIdValue;
- (int32_t)feedIdValue;
- (void)setFeedIdValue:(int32_t)value_;

//- (BOOL)validateFeedId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMFeed *feed;

//- (BOOL)validateFeed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _TMUserLikeFeed (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveFeedId;
- (void)setPrimitiveFeedId:(NSNumber*)value;

- (int32_t)primitiveFeedIdValue;
- (void)setPrimitiveFeedIdValue:(int32_t)value_;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;

- (TMFeed*)primitiveFeed;
- (void)setPrimitiveFeed:(TMFeed*)value;

- (TMUser*)primitiveUser;
- (void)setPrimitiveUser:(TMUser*)value;

@end
