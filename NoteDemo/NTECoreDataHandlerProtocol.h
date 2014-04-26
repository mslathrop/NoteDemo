//
//  NTECoreDataHandlerProtocol.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NTECoreDataHandlerProtocol <NSObject>

// getters
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;

/**
 Initializes the core data stack, however the managed object context is lazily created
 
 @param storeURL The URL pointing to the sqlite store on the device. The store will be created if it doesn't already exist at the specified location
 @param modelURL The URL pointing the xcdatamodel on the device. This must already exist
 */
- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

/**
 Saves the managed object context
 */
- (void)saveManagedObjectContext;

@end
