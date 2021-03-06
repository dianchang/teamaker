// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeam.m instead.

#import "_TMTeam.h"

const struct TMTeamAttributes TMTeamAttributes = {
	.avatar = @"avatar",
	.id = @"id",
	.name = @"name",
	.qrcode = @"qrcode",
};

const struct TMTeamRelationships TMTeamRelationships = {
	.feeds = @"feeds",
	.usersInfos = @"usersInfos",
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

@dynamic name;

@dynamic qrcode;

@dynamic feeds;

- (NSMutableSet*)feedsSet {
	[self willAccessValueForKey:@"feeds"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"feeds"];

	[self didAccessValueForKey:@"feeds"];
	return result;
}

@dynamic usersInfos;

- (NSMutableSet*)usersInfosSet {
	[self willAccessValueForKey:@"usersInfos"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"usersInfos"];

	[self didAccessValueForKey:@"usersInfos"];
	return result;
}

@end

