//
//  NTEHandlerFactory.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocols
#import "NTECoreDataHandlerProtocol.h"
#import "NTENoteHandlerProtocol.h"

/**
 Not exactly a factory, but this is responsible for returning the appropriate 
 handlers for each handler protocol that has been defined
 */
@interface NTEHandlerProvider : NSObject

+ (instancetype)sharedInstance;

/**
 Lazily initializes and provides access to the core data handler
 */
+ (id<NTECoreDataHandlerProtocol>) coreDataHandler;

/**
 Lazily initializes and provides access to the note handler
 */
+ (id<NTENoteHandlerProtocol>) noteHandler;

@end
