// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMFeed.m instead.

#import "_TMFeed.h"

const struct TMFeedAttributes TMFeedAttributes = {
	.id = @"id",
	.image = @"image",
	.kind = @"kind",
	.location = @"location",
	.punch = @"punch",
	.team_id = @"team_id",
	.text = @"text",
	.userAvatar = @"userAvatar",
	.user_id = @"user_id",
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
	if ([key isEqualToString:@"team_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"team_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"user_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"user_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

- (int64_t)idValue {
	NSNumber *result = [self id];
	return [result longLongValue];
}

- (void)setIdValue:(int64_t)value_ {
	[self setId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result longLongValue];
}

- (void)setPrimitiveIdValue:(int64_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithLongLong:value_]];
}

@dynamic image;

@dynamic kind;

@dynamic location;

@dynamic punch;

@dynamic team_id;

- (int64_t)team_idValue {
	NSNumber *result = [self team_id];
	return [result longLongValue];
}

- (void)setTeam_idValue:(int64_t)value_ {
	[self setTeam_id:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTeam_idValue {
	NSNumber *result = [self primitiveTeam_id];
	return [result longLongValue];
}

- (void)setPrimitiveTeam_idValue:(int64_t)value_ {
	[self setPrimitiveTeam_id:[NSNumber numberWithLongLong:value_]];
}

@dynamic text;

@dynamic userAvatar;

@dynamic user_id;

- (int64_t)user_idValue {
	NSNumber *result = [self user_id];
	return [result longLongValue];
}

- (void)setUser_idValue:(int64_t)value_ {
	[self setUser_id:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveUser_idValue {
	NSNumber *result = [self primitiveUser_id];
	return [result longLongValue];
}

- (void)setPrimitiveUser_idValue:(int64_t)value_ {
	[self setPrimitiveUser_id:[NSNumber numberWithLongLong:value_]];
}

@dynamic team;

@dynamic user;

@end

