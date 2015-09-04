// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeed.h instead.

#import <CoreData/CoreData.h>

extern const struct TMFeedAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *d;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *imageUrl;
	__unsafe_unretained NSString *kind;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *punch;
	__unsafe_unretained NSString *shareUrl;
	__unsafe_unretained NSString *teamId;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *userId;
} TMFeedAttributes;

extern const struct TMFeedRelationships {
	__unsafe_unretained NSString *team;
	__unsafe_unretained NSString *user;
} TMFeedRelationships;

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

@property (nonatomic, strong) NSNumber* d;

@property (atomic) int16_t dValue;
- (int16_t)dValue;
- (void)setDValue:(int16_t)value_;

//- (BOOL)validateD:(id*)value_ error:(NSError**)error_;

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

@property (nonatomic, strong) NSNumber* shareUrl;

@property (atomic) int32_t shareUrlValue;
- (int32_t)shareUrlValue;
- (void)setShareUrlValue:(int32_t)value_;

//- (BOOL)validateShareUrl:(id*)value_ error:(NSError**)error_;

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

@property (nonatomic, strong) TMTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _TMFeed (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSNumber*)primitiveD;
- (void)setPrimitiveD:(NSNumber*)value;

- (int16_t)primitiveDValue;
- (void)setPrimitiveDValue:(int16_t)value_;

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

- (NSNumber*)primitiveShareUrl;
- (void)setPrimitiveShareUrl:(NSNumber*)value;

- (int32_t)primitiveShareUrlValue;
- (void)setPrimitiveShareUrlValue:(int32_t)value_;

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

- (TMTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(TMTeam*)value;

- (TMUser*)primitiveUser;
- (void)setPrimitiveUser:(TMUser*)value;

@end
