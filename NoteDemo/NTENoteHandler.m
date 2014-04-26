//
//  NTENoteHandler.m
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import "NTENoteHandler.h"

// Models
#import "NTENote.h"

@implementation NTENoteHandler

- (NTENote *)newNoteWithTitle:(NSString *)title body:(NSString *)body inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSAssert(managedObjectContext != nil, @"managedObjectContext cannot be null");
    
    NTENote *ret = [NTENote insertInManagedObjectContext:managedObjectContext];
    ret.body = body;
    ret.title = title;
    ret.entityId = [[NSUUID UUID] UUIDString];
    return ret;
}

- (NTENote *)retrieveNoteWithEntityId:(NSString *)entityId inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSAssert(managedObjectContext != nil, @"managedObjectContext cannot be null");
    
    // return if id was nil
    if (!entityId) {
        return nil;
    }
    
    NTENote *ret = nil;
    NSEntityDescription *entity = [NTENote entityInManagedObjectContext:managedObjectContext];
    
    // set up the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entityId == %@", entityId];
	[request setPredicate:predicate];
	[request setEntity:entity];
    
    // get fetch results
    NSArray *fetchResults = [self performFetchRequest:request inManagedObjectContext:managedObjectContext];
    
    // return first result
    if (fetchResults.count > 0) {
        ret = fetchResults[0];
    }
    
    return ret;
}

#pragma mark - private methods

- (NSArray *)performFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	NSError *error;
	NSArray *fetchResults = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (!fetchResults) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return fetchResults;
}

@end