// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeed.h instead.

#import <CoreData/CoreData.h>

extern const struct TMFeedAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *imageUrl;
	__unsafe_unretained NSString *kind;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *punch;
	__unsafe_unretained NSString *shareImageUrl;
	__unsafe_unretained NSString *shareTitle;
	__unsafe_unretained NSString *shareUrl;
	__unsafe_unretained NSString *starred;
	__unsafe_unretained NSString *teamId;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *userId;
} TMFeedAttributes;

extern const struct TMFeedRelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *likers;
	__unsafe_unretained NSString *team;
	__unsafe_unretained NSString *user;
} TMFeedRelationships;

@class TMFeedComment;
@class TMUserLikeFeed;
@class TMTeam;
@class TMUser;

@interface TMFeedID : NSManagedObjectID {}
@end

@interface _TMFeed : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMFeedID* objectID;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imageUrl;

//- (BOOL)validateImageUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* kind;

//- (BOOL)validateKind:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* punch;

//- (BOOL)validatePunch:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shareImageUrl;

//- (BOOL)validateShareImageUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shareTitle;

//- (BOOL)validateShareTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shareUrl;

//- (BOOL)validateShareUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* starred;

@property (atomic) BOOL starredValue;
- (BOOL)starredValue;
- (void)setStarredValue:(BOOL)value_;

//- (BOOL)validateStarred:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* teamId;

@property (atomic) int32_t teamIdValue;
- (int32_t)teamIdValue;
- (void)setTeamIdValue:(int32_t)value_;

//- (BOOL)validateTeamId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *comments;

- (NSMutableSet*)commentsSet;

@property (nonatomic, strong) NSSet *likers;

- (NSMutableSet*)likersSet;

@property (nonatomic, strong) TMTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _TMFeed (CommentsCoreDataGeneratedAccessors)
- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(TMFeedComment*)value_;
- (void)removeCommentsObject:(TMFeedComment*)value_;

@end

@interface _TMFeed (LikersCoreDataGeneratedAccessors)
- (void)addLikers:(NSSet*)value_;
- (void)removeLikers:(NSSet*)value_;
- (void)addLikersObject:(TMUserLikeFeed*)value_;
- (void)removeLikersObject:(TMUserLikeFeed*)value_;

@end

@interface _TMFeed (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;

- (NSString*)primitiveImageUrl;
- (void)setPrimitiveImageUrl:(NSString*)value;

- (NSString*)primitiveKind;
- (void)setPrimitiveKind:(NSString*)value;

- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;

- (NSString*)primitivePunch;
- (void)setPrimitivePunch:(NSString*)value;

- (NSString*)primitiveShareImageUrl;
- (void)setPrimitiveShareImageUrl:(NSString*)value;

- (NSString*)primitiveShareTitle;
- (void)setPrimitiveShareTitle:(NSString*)value;

- (NSString*)primitiveShareUrl;
- (void)setPrimitiveShareUrl:(NSString*)value;

- (NSNumber*)primitiveStarred;
- (void)setPrimitiveStarred:(NSNumber*)value;

- (BOOL)primitiveStarredValue;
- (void)setPrimitiveStarredValue:(BOOL)value_;

- (NSNumber*)primitiveTeamId;
- (void)setPrimitiveTeamId:(NSNumber*)value;

- (int32_t)primitiveTeamIdValue;
- (void)setPrimitiveTeamIdValue:(int32_t)value_;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;

- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;

- (NSMutableSet*)primitiveLikers;
- (void)setPrimitiveLikers:(NSMutableSet*)value;

- (TMTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(TMTeam*)value;

- (TMUser*)primitiveUser;
- (void)setPrimitiveUser:(TMUser*)value;

@end
