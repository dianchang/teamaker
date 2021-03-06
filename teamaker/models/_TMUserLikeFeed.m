// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUserLikeFeed.m instead.

#import "_TMUserLikeFeed.h"

const struct TMUserLikeFeedAttributes TMUserLikeFeedAttributes = {
	.createdAt = @"createdAt",
	.feedId = @"feedId",
	.id = @"id",
	.userId = @"userId",
};

const struct TMUserLikeFeedRelationships TMUserLikeFeedRelationships = {
	.feed = @"feed",
	.user = @"user",
};

@implementation TMUserLikeFeedID
@end

@implementation _TMUserLikeFeed

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TMUserLikeFeed" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TMUserLikeFeed";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TMUserLikeFeed" inManagedObjectContext:moc_];
}

- (TMUserLikeFeedID*)objectID {
	return (TMUserLikeFeedID*)[super objectID];
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
	if ([key isEqualToString:@"userIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

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

@dynamic user;

@end

