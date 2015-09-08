// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUserLikeFeed.m instead.

#import "_TMUserLikeFeed.h"

const struct TMUserLikeFeedAttributes TMUserLikeFeedAttributes = {
	.createdAt = @"createdAt",
	.id = @"id",
	.teamId = @"teamId",
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

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"teamIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"teamId"];
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

@dynamic teamId;

- (int32_t)teamIdValue {
	NSNumber *result = [self teamId];
	return [result intValue];
}

- (void)setTeamIdValue:(int32_t)value_ {
	[self setTeamId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTeamIdValue {
	NSNumber *result = [self primitiveTeamId];
	return [result intValue];
}

- (void)setPrimitiveTeamIdValue:(int32_t)value_ {
	[self setPrimitiveTeamId:[NSNumber numberWithInt:value_]];
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

