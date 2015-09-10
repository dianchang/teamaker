// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUser.h instead.

#import <CoreData/CoreData.h>

extern const struct TMUserAttributes {
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *motto;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *phone;
	__unsafe_unretained NSString *province;
	__unsafe_unretained NSString *qrcode;
	__unsafe_unretained NSString *sex;
	__unsafe_unretained NSString *wechat;
} TMUserAttributes;

extern const struct TMUserRelationships {
	__unsafe_unretained NSString *comments;
	__unsafe_unretained NSString *feeds;
	__unsafe_unretained NSString *likedFeeds;
	__unsafe_unretained NSString *targetedComments;
	__unsafe_unretained NSString *teamsInfos;
} TMUserRelationships;

@class TMFeedComment;
@class TMFeed;
@class TMUserLikeFeed;
@class TMFeedComment;
@class TMTeamUserInfo;

@interface TMUserID : NSManagedObjectID {}
@end

@interface _TMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TMUserID* objectID;

@property (nonatomic, strong) NSString* avatar;

//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* motto;

//- (BOOL)validateMotto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phone;

//- (BOOL)validatePhone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* province;

//- (BOOL)validateProvince:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* qrcode;

//- (BOOL)validateQrcode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sex;

//- (BOOL)validateSex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* wechat;

//- (BOOL)validateWechat:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *comments;

- (NSMutableSet*)commentsSet;

@property (nonatomic, strong) NSSet *feeds;

- (NSMutableSet*)feedsSet;

@property (nonatomic, strong) NSSet *likedFeeds;

- (NSMutableSet*)likedFeedsSet;

@property (nonatomic, strong) TMFeedComment *targetedComments;

//- (BOOL)validateTargetedComments:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *teamsInfos;

- (NSMutableSet*)teamsInfosSet;

@end

@interface _TMUser (CommentsCoreDataGeneratedAccessors)
- (void)addComments:(NSSet*)value_;
- (void)removeComments:(NSSet*)value_;
- (void)addCommentsObject:(TMFeedComment*)value_;
- (void)removeCommentsObject:(TMFeedComment*)value_;

@end

@interface _TMUser (FeedsCoreDataGeneratedAccessors)
- (void)addFeeds:(NSSet*)value_;
- (void)removeFeeds:(NSSet*)value_;
- (void)addFeedsObject:(TMFeed*)value_;
- (void)removeFeedsObject:(TMFeed*)value_;

@end

@interface _TMUser (LikedFeedsCoreDataGeneratedAccessors)
- (void)addLikedFeeds:(NSSet*)value_;
- (void)removeLikedFeeds:(NSSet*)value_;
- (void)addLikedFeedsObject:(TMUserLikeFeed*)value_;
- (void)removeLikedFeedsObject:(TMUserLikeFeed*)value_;

@end

@interface _TMUser (TeamsInfosCoreDataGeneratedAccessors)
- (void)addTeamsInfos:(NSSet*)value_;
- (void)removeTeamsInfos:(NSSet*)value_;
- (void)addTeamsInfosObject:(TMTeamUserInfo*)value_;
- (void)removeTeamsInfosObject:(TMTeamUserInfo*)value_;

@end

@interface _TMUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAvatar;
- (void)setPrimitiveAvatar:(NSString*)value;

- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSString*)primitiveMotto;
- (void)setPrimitiveMotto:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePhone;
- (void)setPrimitivePhone:(NSString*)value;

- (NSString*)primitiveProvince;
- (void)setPrimitiveProvince:(NSString*)value;

- (NSString*)primitiveQrcode;
- (void)setPrimitiveQrcode:(NSString*)value;

- (NSString*)primitiveSex;
- (void)setPrimitiveSex:(NSString*)value;

- (NSString*)primitiveWechat;
- (void)setPrimitiveWechat:(NSString*)value;

- (NSMutableSet*)primitiveComments;
- (void)setPrimitiveComments:(NSMutableSet*)value;

- (NSMutableSet*)primitiveFeeds;
- (void)setPrimitiveFeeds:(NSMutableSet*)value;

- (NSMutableSet*)primitiveLikedFeeds;
- (void)setPrimitiveLikedFeeds:(NSMutableSet*)value;

- (TMFeedComment*)primitiveTargetedComments;
- (void)setPrimitiveTargetedComments:(TMFeedComment*)value;

- (NSMutableSet*)primitiveTeamsInfos;
- (void)setPrimitiveTeamsInfos:(NSMutableSet*)value;

@end
