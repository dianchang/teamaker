// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeed.h instead.

#import <CoreData/CoreData.h>

extern const struct TMFeedAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *kind;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *punch;
	__unsafe_unretained NSString *team_id;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *userAvatar;
	__unsafe_unretained NSString *user_id;
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

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* kind;

//- (BOOL)validateKind:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* punch;

//- (BOOL)validatePunch:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* team_id;

@property (atomic) int64_t team_idValue;
- (int64_t)team_idValue;
- (void)setTeam_idValue:(int64_t)value_;

//- (BOOL)validateTeam_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userAvatar;

//- (BOOL)validateUserAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* user_id;

@property (atomic) int64_t user_idValue;
- (int64_t)user_idValue;
- (void)setUser_idValue:(int64_t)value_;

//- (BOOL)validateUser_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _TMFeed (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveKind;
- (void)setPrimitiveKind:(NSString*)value;

- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;

- (NSString*)primitivePunch;
- (void)setPrimitivePunch:(NSString*)value;

- (NSNumber*)primitiveTeam_id;
- (void)setPrimitiveTeam_id:(NSNumber*)value;

- (int64_t)primitiveTeam_idValue;
- (void)setPrimitiveTeam_idValue:(int64_t)value_;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveUserAvatar;
- (void)setPrimitiveUserAvatar:(NSString*)value;

- (NSNumber*)primitiveUser_id;
- (void)setPrimitiveUser_id:(NSNumber*)value;

- (int64_t)primitiveUser_idValue;
- (void)setPrimitiveUser_idValue:(int64_t)value_;

- (TMTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(TMTeam*)value;

- (TMUser*)primitiveUser;
- (void)setPrimitiveUser:(TMUser*)value;

@end
