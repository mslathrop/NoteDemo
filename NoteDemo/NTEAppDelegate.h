//
//  NTEAppDelegate.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTECoreDataHandler;

@interface NTEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 Lazily initializes and provides access to the core data stack
 */
@property (strong, nonatomic) NTECoreDataHandler *coreDataHandler;

@end
