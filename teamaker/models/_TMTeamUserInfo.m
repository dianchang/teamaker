// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeamUserInfo.m instead.

#import "_TMTeamUserInfo.h"

const struct TMTeamUserInfoAttributes TMTeamUserInfoAttributes = {
	.avatar = @"avatar",
	.desc = @"desc",
	.id = @"id",
	.name = @"name",
	.teamId = @"teamId",
	.userId = @"userId",
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

@dynamic teamId;

- (int64_t)teamIdValue {
	NSNumber *result = [self teamId];
	return [result longLongValue];
}

- (void)setTeamIdValue:(int64_t)value_ {
	[self setTeamId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveTeamIdValue {
	NSNumber *result = [self primitiveTeamId];
	return [result longLongValue];
}

- (void)setPrimitiveTeamIdValue:(int64_t)value_ {
	[self setPrimitiveTeamId:[NSNumber numberWithLongLong:value_]];
}

@dynamic userId;

- (int64_t)userIdValue {
	NSNumber *result = [self userId];
	return [result longLongValue];
}

- (void)setUserIdValue:(int64_t)value_ {
	[self setUserId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveUserIdValue {
	NSNumber *result = [self primitiveUserId];
	return [result longLongValue];
}

- (void)setPrimitiveUserIdValue:(int64_t)value_ {
	[self setPrimitiveUserId:[NSNumber numberWithLongLong:value_]];
}

@dynamic team;

@dynamic user;

@end

