// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TMUser.m instead.

#import "_TMUser.h"

const struct TMUserAttributes TMUserAttributes = {
	.avatar = @"avatar",
	.city = @"city",
	.email = @"email",
	.id = @"id",
	.motto = @"motto",
	.name = @"name",
	.phone = @"phone",
	.province = @"province",
	.qrcode = @"qrcode",
	.sex = @"sex",
	.wechat = @"wechat",
};

const struct TMUserRelationships TMUserRelationships = {
	.feeds = @"feeds",
	.teamsInfos = @"teamsInfos",
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

@dynamic avatar;

@dynamic city;

@dynamic email;

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

@dynamic motto;

@dynamic name;

@dynamic phone;

@dynamic province;

@dynamic qrcode;

@dynamic sex;

@dynamic wechat;

@dynamic feeds;

- (NSMutableSet*)feedsSet {
	[self willAccessValueForKey:@"feeds"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"feeds"];

	[self didAccessValueForKey:@"feeds"];
	return result;
}

@dynamic teamsInfos;

- (NSMutableSet*)teamsInfosSet {
	[self willAccessValueForKey:@"teamsInfos"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teamsInfos"];

	[self didAccessValueForKey:@"teamsInfos"];
	return result;
}

@end

