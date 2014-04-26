// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NTENote.m instead.

#import "_NTENote.h"

const struct NTENoteAttributes NTENoteAttributes = {
	.body = @"body",
	.entityId = @"entityId",
	.title = @"title",
};

const struct NTENoteRelationships NTENoteRelationships = {
};

const struct NTENoteFetchedProperties NTENoteFetchedProperties = {
};

@implementation NTENoteID
@end

@implementation _NTENote

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"NTENote" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"NTENote";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"NTENote" inManagedObjectContext:moc_];
}

- (NTENoteID*)objectID {
	return (NTENoteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic body;






@dynamic entityId;






@dynamic title;











@end
