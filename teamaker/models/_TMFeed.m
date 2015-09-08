// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeed.m instead.

#import "_TMFeed.h"

const struct TMFeedAttributes TMFeedAttributes = {
	.createdAt = @"createdAt",
	.id = @"id",
	.image = @"image",
	.imageUrl = @"imageUrl",
	.kind = @"kind",
	.location = @"location",
	.punch = @"punch",
	.shareImageUrl = @"shareImageUrl",
	.shareTitle = @"shareTitle",
	.shareUrl = @"shareUrl",
	.starred = @"starred",
	.teamId = @"teamId",
	.text = @"text",
	.userId = @"userId",
};

const struct TMFeedRelationships TMFeedRelationships = {
	.team = @"team",
	.user = @"user",
};

@implementation TMFeedID
@end

@implementation _TMFeed

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TMFeed" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TMFeed";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TMFeed" inManagedObjectContext:moc_];
}

- (TMFeedID*)objectID {
	return (TMFeedID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"starredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"starred"];
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

@dynamic image;

@dynamic imageUrl;

@dynamic kind;

@dynamic location;

@dynamic punch;

@dynamic shareImageUrl;

@dynamic shareTitle;

@dynamic shareUrl;

@dynamic starred;

- (BOOL)starredValue {
	NSNumber *result = [self starred];
	return [result boolValue];
}

- (void)setStarredValue:(BOOL)value_ {
	[self setStarred:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveStarredValue {
	NSNumber *result = [self primitiveStarred];
	return [result boolValue];
}

- (void)setPrimitiveStarredValue:(BOOL)value_ {
	[self setPrimitiveStarred:[NSNumber numberWithBool:value_]];
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

@dynamic text;

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

@dynamic team;

@dynamic user;

@end

