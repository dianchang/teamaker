// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeam.m instead.

#import "_TMTeam.h"

const struct TMTeamAttributes TMTeamAttributes = {
	.avatar = @"avatar",
	.id = @"id",
	.name = @"name",
};

const struct TMTeamRelationships TMTeamRelationships = {
	.feeds = @"feeds",
	.users = @"users",
};

@implementation TMTeamID
@end

@implementation _TMTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TMTeam" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TMTeam";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TMTeam" inManagedObjectContext:moc_];
}

- (TMTeamID*)objectID {
	return (TMTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic avatar;

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

@dynamic name;

@dynamic feeds;

- (NSMutableSet*)feedsSet {
	[self willAccessValueForKey:@"feeds"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"feeds"];

	[self didAccessValueForKey:@"feeds"];
	return result;
}

@dynamic users;

- (NSMutableSet*)usersSet {
	[self willAccessValueForKey:@"users"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"users"];

	[self didAccessValueForKey:@"users"];
	return result;
}

@end

