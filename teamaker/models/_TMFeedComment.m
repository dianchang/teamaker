// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeedComment.m instead.

#import "_TMFeedComment.h"

const struct TMFeedCommentAttributes TMFeedCommentAttributes = {
	.content = @"content",
	.createdAt = @"createdAt",
	.feedId = @"feedId",
	.id = @"id",
	.targetUserId = @"targetUserId",
	.userId = @"userId",
};

const struct TMFeedCommentRelationships TMFeedCommentRelationships = {
	.feed = @"feed",
	.targetUser = @"targetUser",
	.user = @"user",
};

@implementation TMFeedCommentID
@end

@implementation _TMFeedComment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TMFeedComment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TMFeedComment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TMFeedComment" inManagedObjectContext:moc_];
}

- (TMFeedCommentID*)objectID {
	return (TMFeedCommentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"feedIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"feedId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"targetUserIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"targetUserId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"userIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic content;

@dynamic createdAt;

@dynamic feedId;

- (int32_t)feedIdValue {
	NSNumber *result = [self feedId];
	return [result intValue];
}

- (void)setFeedIdValue:(int32_t)value_ {
	[self setFeedId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFeedIdValue {
	NSNumber *result = [self primitiveFeedId];
	return [result intValue];
}

- (void)setPrimitiveFeedIdValue:(int32_t)value_ {
	[self setPrimitiveFeedId:[NSNumber numberWithInt:value_]];
}

@dynamic id;

- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithInt:value_]];
}

@dynamic targetUserId;

- (int32_t)targetUserIdValue {
	NSNumber *result = [self targetUserId];
	return [result intValue];
}

- (void)setTargetUserIdValue:(int32_t)value_ {
	[self setTargetUserId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTargetUserIdValue {
	NSNumber *result = [self primitiveTargetUserId];
	return [result intValue];
}

- (void)setPrimitiveTargetUserIdValue:(int32_t)value_ {
	[self setPrimitiveTargetUserId:[NSNumber numberWithInt:value_]];
}

@dynamic userId;

- (int32_t)userIdValue {
	NSNumber *result = [self userId];
	return [result intValue];
}

- (void)setUserIdValue:(int32_t)value_ {
	[self setUserId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveUserIdValue {
	NSNumber *result = [self primitiveUserId];
	return [result intValue];
}

- (void)setPrimitiveUserIdValue:(int32_t)value_ {
	[self setPrimitiveUserId:[NSNumber numberWithInt:value_]];
}

@dynamic feed;

@dynamic targetUser;

@dynamic user;

@end

