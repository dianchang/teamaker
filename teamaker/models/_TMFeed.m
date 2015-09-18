// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeed.m instead.

#import "_TMFeed.h"

const struct TMFeedAttributes TMFeedAttributes = {
	.createdAt = @"createdAt",
	.height = @"height",
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
	.width = @"width",
};

const struct TMFeedRelationships TMFeedRelationships = {
	.comments = @"comments",
	.likers = @"likers",
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

	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
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
	if ([key isEqualToString:@"widthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"width"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic height;

- (float)heightValue {
	NSNumber *result = [self height];
	return [result floatValue];
}

- (void)setHeightValue:(float)value_ {
	[self setHeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result floatValue];
}

- (void)setPrimitiveHeightValue:(float)value_ {
	[self setPrimitiveHeight:[NSNumber numberWithFloat:value_]];
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

@dynamic width;

- (float)widthValue {
	NSNumber *result = [self width];
	return [result floatValue];
}

- (void)setWidthValue:(float)value_ {
	[self setWidth:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveWidthValue {
	NSNumber *result = [self primitiveWidth];
	return [result floatValue];
}

- (void)setPrimitiveWidthValue:(float)value_ {
	[self setPrimitiveWidth:[NSNumber numberWithFloat:value_]];
}

@dynamic comments;

- (NSMutableSet*)commentsSet {
	[self willAccessValueForKey:@"comments"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"comments"];

	[self didAccessValueForKey:@"comments"];
	return result;
}

@dynamic likers;

- (NSMutableSet*)likersSet {
	[self willAccessValueForKey:@"likers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"likers"];

	[self didAccessValueForKey:@"likers"];
	return result;
}

@dynamic team;

@dynamic user;

@end

