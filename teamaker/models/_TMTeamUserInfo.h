// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeamUserInfo.h instead.

#import <CoreData/CoreData.h>

extern const struct TMTeamUserInfoAttributes {
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *desc;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *teamId;
	__unsafe_unretained NSString *userId;
} TMTeamUserInfoAttributes;

extern const struct TMTeamUserInfoRelationships {
	__unsafe_unretained NSString *team;
	__unsafe_unretained NSString *user;
} TMTeamUserInfoRelationships;

@class TMTeam;
@class TMUser;

@interface TMTeamUserInfoID : NSManagedObjectID {}
@end

@interface _TMTeamUserInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMTeamUserInfoID* objectID;

@property (nonatomic, strong) NSString* avatar;

//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* desc;

//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* teamId;

@property (atomic) int64_t teamIdValue;
- (int64_t)teamIdValue;
- (void)setTeamIdValue:(int64_t)value_;

//- (BOOL)validateTeamId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* userId;

@property (atomic) int64_t userIdValue;
- (int64_t)userIdValue;
- (void)setUserIdValue:(int64_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _TMTeamUserInfo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAvatar;
- (void)setPrimitiveAvatar:(NSString*)value;

- (NSString*)primitiveDesc;
- (void)setPrimitiveDesc:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveTeamId;
- (void)setPrimitiveTeamId:(NSNumber*)value;

- (int64_t)primitiveTeamIdValue;
- (void)setPrimitiveTeamIdValue:(int64_t)value_;

- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int64_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int64_t)value_;

- (TMTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(TMTeam*)value;

- (TMUser*)primitiveUser;
- (void)setPrimitiveUser:(TMUser*)value;

@end