// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeedComment.h instead.

#import <CoreData/CoreData.h>

extern const struct TMFeedCommentAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *feedId;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *targetUserId;
	__unsafe_unretained NSString *userId;
} TMFeedCommentAttributes;

extern const struct TMFeedCommentRelationships {
	__unsafe_unretained NSString *feed;
	__unsafe_unretained NSString *targetUser;
	__unsafe_unretained NSString *user;
} TMFeedCommentRelationships;

@class TMFeed;
@class TMUser;
@class TMUser;

@interface TMFeedCommentID : NSManagedObjectID {}
@end

@interface _TMFeedComment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMFeedCommentID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

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

@property (nonatomic, strong) NSNumber* targetUserId;

@property (atomic) int32_t targetUserIdValue;
- (int32_t)targetUserIdValue;
- (void)setTargetUserIdValue:(int32_t)value_;

//- (BOOL)validateTargetUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMFeed *feed;

//- (BOOL)validateFeed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *targetUser;

//- (BOOL)validateTargetUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _TMFeedComment (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

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

- (NSNumber*)primitiveTargetUserId;
- (void)setPrimitiveTargetUserId:(NSNumber*)value;

- (int32_t)primitiveTargetUserIdValue;
- (void)setPrimitiveTargetUserIdValue:(int32_t)value_;

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;

- (TMFeed*)primitiveFeed;
- (void)setPrimitiveFeed:(TMFeed*)value;

- (TMUser*)primitiveTargetUser;
- (void)setPrimitiveTargetUser:(TMUser*)value;

- (TMUser*)primitiveUser;
- (void)setPrimitiveUser:(TMUser*)value;

@end
