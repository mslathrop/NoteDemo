//
//  NTEAppDelegate.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "NTECoreDataHandlerProtocol.h"
#import "NTENoteHandlerProtocol.h"

@interface NTEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 Lazily initializes and provides access to the core data handler
 */
- (id<NTECoreDataHandlerProtocol>) coreDataHandler;

/**
 Lazily initializes and provides access to the core data handler
 */
- (id<NTENoteHandlerProtocol>) noteHandler;

@end
