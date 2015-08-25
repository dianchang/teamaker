// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUser.m instead.

#import "_TMUser.h"

const struct TMUserAttributes TMUserAttributes = {
	.email = @"email",
	.id = @"id",
	.name = @"name",
};

const struct TMUserRelationships TMUserRelationships = {
	.feeds = @"feeds",
};

@implementation TMUserID
@end

@implementation _TMUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TMUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TMUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TMUser" inManagedObjectContext:moc_];
}

- (TMUserID*)objectID {
	return (TMUserID*)[super objectID];
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

@dynamic email;

@dynamic id;

- (BOOL)idValue {
	NSNumber *result = [self id];
	return [result boolValue];
}

- (void)setIdValue:(BOOL)value_ {
	[self setId:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result boolValue];
}

- (void)setPrimitiveIdValue:(BOOL)value_ {
	[self setPrimitiveId:[NSNumber numberWithBool:value_]];
}

@dynamic name;

@dynamic feeds;

- (NSMutableSet*)feedsSet {
	[self willAccessValueForKey:@"feeds"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"feeds"];

	[self didAccessValueForKey:@"feeds"];
	return result;
}

@end

