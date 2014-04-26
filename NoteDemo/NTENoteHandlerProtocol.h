//
//  NTENoteHandlerProtocol.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTENote;

@protocol NTENoteHandlerProtocol <NSObject>

/**
 Creates a new note with title and body inside the specified managed object context
 
 @param title The title of the note
 @param body The body of the note
 @param managedObjectContext The managed object context that the entity will be created in
 */
- (NTENote *)newNoteWithTitle:(NSString *)title body:(NSString *)body inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 Creates a new note with title and body inside the specified managed object context
 
 @param entityId The entityId of the NTENote that should be retrieved
 @param managedObjectContext The managed object context that the entity will be created in
 */
- (NTENote *)retrieveNoteWithEntityId:(NSString *)entityId inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
