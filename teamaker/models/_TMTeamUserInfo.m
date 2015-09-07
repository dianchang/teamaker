// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMTeamUserInfo.m instead.

#import "_TMTeamUserInfo.h"

const struct TMTeamUserInfoAttributes TMTeamUserInfoAttributes = {
	.avatar = @"avatar",
	.createdAt = @"createdAt",
	.desc = @"desc",
	.id = @"id",
	.membersCountInvitedViaContact = @"membersCountInvitedViaContact",
	.membersCountInvitedViaEmail = @"membersCountInvitedViaEmail",
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
	if ([key isEqualToString:@"membersCountInvitedViaContactValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"membersCountInvitedViaContact"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"membersCountInvitedViaEmailValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"membersCountInvitedViaEmail"];
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

@dynamic createdAt;

@dynamic desc;

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

@dynamic membersCountInvitedViaContact;

- (int32_t)membersCountInvitedViaContactValue {
	NSNumber *result = [self membersCountInvitedViaContact];
	return [result intValue];
}

- (void)setMembersCountInvitedViaContactValue:(int32_t)value_ {
	[self setMembersCountInvitedViaContact:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMembersCountInvitedViaContactValue {
	NSNumber *result = [self primitiveMembersCountInvitedViaContact];
	return [result intValue];
}

- (void)setPrimitiveMembersCountInvitedViaContactValue:(int32_t)value_ {
	[self setPrimitiveMembersCountInvitedViaContact:[NSNumber numberWithInt:value_]];
}

@dynamic membersCountInvitedViaEmail;

- (int32_t)membersCountInvitedViaEmailValue {
	NSNumber *result = [self membersCountInvitedViaEmail];
	return [result intValue];
}

- (void)setMembersCountInvitedViaEmailValue:(int32_t)value_ {
	[self setMembersCountInvitedViaEmail:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMembersCountInvitedViaEmailValue {
	NSNumber *result = [self primitiveMembersCountInvitedViaEmail];
	return [result intValue];
}

- (void)setPrimitiveMembersCountInvitedViaEmailValue:(int32_t)value_ {
	[self setPrimitiveMembersCountInvitedViaEmail:[NSNumber numberWithInt:value_]];
}

@dynamic name;

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

@dynamic team;

@dynamic user;

@end

