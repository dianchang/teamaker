// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeamUserInfo.m instead.

#import "_TMTeamUserInfo.h"

const struct TMTeamUserInfoAttributes TMTeamUserInfoAttributes = {
	.avatar = @"avatar",
	.desc = @"desc",
	.id = @"id",
	.name = @"name",
};

const struct TMTeamUserInfoRelationships TMTeamUserInfoRelationships = {
	.team = @"team",
	.user = @"user",
};

@implementation TMTeamUserInfoID
@end

@implementation _TMTeamUserInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TMTeamUserInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TMTeamUserInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TMTeamUserInfo" inManagedObjectContext:moc_];
}

- (TMTeamUserInfoID*)objectID {
	return (TMTeamUserInfoID*)[super objectID];
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

@dynamic desc;

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

@dynamic team;

@dynamic user;

@end

