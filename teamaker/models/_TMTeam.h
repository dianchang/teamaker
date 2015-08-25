// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeam.h instead.

#import <CoreData/CoreData.h>

extern const struct TMTeamAttributes {
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} TMTeamAttributes;

extern const struct TMTeamRelationships {
	__unsafe_unretained NSString *feeds;
} TMTeamRelationships;

@class TMFeed;

@interface TMTeamID : NSManagedObjectID {}
@end

@interface _TMTeam : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMTeamID* objectID;

@property (nonatomic, strong) NSString* avatar;

//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *feeds;

- (NSMutableSet*)feedsSet;

@end

@interface _TMTeam (FeedsCoreDataGeneratedAccessors)
- (void)addFeeds:(NSSet*)value_;
- (void)removeFeeds:(NSSet*)value_;
- (void)addFeedsObject:(TMFeed*)value_;
- (void)removeFeedsObject:(TMFeed*)value_;

@end

@interface _TMTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAvatar;
- (void)setPrimitiveAvatar:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveFeeds;
- (void)setPrimitiveFeeds:(NSMutableSet*)value;

@end
