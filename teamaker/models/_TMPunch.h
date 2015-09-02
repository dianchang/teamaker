// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMPunch.h instead.

#import <CoreData/CoreData.h>

extern const struct TMPunchAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *order;
} TMPunchAttributes;

@interface TMPunchID : NSManagedObjectID {}
@end

@interface _TMPunch : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMPunchID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* order;

@property (atomic) int32_t orderValue;
- (int32_t)orderValue;
- (void)setOrderValue:(int32_t)value_;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;

@end

@interface _TMPunch (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSNumber*)primitiveOrder;
- (void)setPrimitiveOrder:(NSNumber*)value;

- (int32_t)primitiveOrderValue;
- (void)setPrimitiveOrderValue:(int32_t)value_;

@end
