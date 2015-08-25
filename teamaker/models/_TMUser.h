// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUser.h instead.

#import <CoreData/CoreData.h>

extern const struct TMUserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} TMUserAttributes;

extern const struct TMUserRelationships {
	__unsafe_unretained NSString *feeds;
} TMUserRelationships;

@class TMFeed;

@interface TMUserID : NSManagedObjectID {}
@end

@interface _TMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMUserID* objectID;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) BOOL idValue;
- (BOOL)idValue;
- (void)setIdValue:(BOOL)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *feeds;

- (NSMutableSet*)feedsSet;

@end

@interface _TMUser (FeedsCoreDataGeneratedAccessors)
- (void)addFeeds:(NSSet*)value_;
- (void)removeFeeds:(NSSet*)value_;
- (void)addFeedsObject:(TMFeed*)value_;
- (void)removeFeedsObject:(TMFeed*)value_;

@end

@interface _TMUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (BOOL)primitiveIdValue;
- (void)setPrimitiveIdValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveFeeds;
- (void)setPrimitiveFeeds:(NSMutableSet*)value;

@end
