//
//  NTEHandlerFactory.m
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import "NTEHandlerProvider.h"

// Handlers
#import "NTECoreDataHandler.h"
#import "NTENoteHandler.h"

// Other
#import "NTEConstants.h"

@interface NTEHandlerProvider ()

@property (strong, nonatomic) id<NTECoreDataHandlerProtocol> coreDataHandler;
@property (strong, nonatomic) id<NTENoteHandlerProtocol> noteHandler;

@end

@implementation NTEHandlerProvider

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (id<NTECoreDataHandlerProtocol>)coreDataHandler {
    NTEHandlerProvider *sharedInstance = [self sharedInstance];
    
    if (!sharedInstance.coreDataHandler) {
        NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                           inDomain:NSUserDomainMask
                                                                  appropriateForURL:nil
                                                                             create:YES
                                                                              error:NULL];
        
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:kNTECoreDataStoreProdName];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kNTECoreDataModelName withExtension:@"momd"];
        
        sharedInstance.coreDataHandler = [[NTECoreDataHandler alloc] initWithStoreURL:storeURL modelURL:modelURL isiCloudEnabled:YES];
    }
    
    return sharedInstance.coreDataHandler;
}

+ (id<NTENoteHandlerProtocol>)noteHandler {
    NTEHandlerProvider *sharedInstance = [self sharedInstance];
    
    if (!sharedInstance.noteHandler) {
        sharedInstance.noteHandler = [[NTENoteHandler alloc] init];
    }
    
    return sharedInstance.noteHandler;
}


@end
