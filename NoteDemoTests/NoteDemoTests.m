//
//  NoteDemoTests.m
//  NoteDemoTests
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <XCTest/XCTest.h>

// Models
#import "NTECoreDataHandler.h"

// Other
#import "NTEConstants.h"

@interface NoteDemoTests : XCTestCase

@property (nonatomic, strong) NTECoreDataHandler *coreDataHandler;

@end

@implementation NoteDemoTests

- (void)setUp
{
    [super setUp];
    
    [self setupCoreDataHandler];
}

- (void)tearDown
{
    
    
    [super tearDown];
}

#pragma mark - core data tests

- (void)testCoreDataHandlerNotNil {
    XCTAssertNotNil(self.coreDataHandler, @"coreDataHandler is nil");
}

- (void)testManagedObjectContextNotNil {
    XCTAssertNotNil(self.coreDataHandler.managedObjectContext, @"managedObjectContext is nil");
}

- (void)testManagedObjectModelNotNil {
    XCTAssertNotNil(self.coreDataHandler.managedObjectContext, @"managedObjectContext is nil");
}

- (void)testPersistentStoreCoordinatorNotNil {
    XCTAssertNotNil(self.coreDataHandler.persistentStoreCoordinator, @"persistentStoreCoordinator is nil");
}

#pragma mark - helper methods

- (void)setupCoreDataHandler {
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    
    NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:kNTECoreDataStoreTestName];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kNTECoreDataModelName withExtension:@"momd"];
    
    self.coreDataHandler = [[NTECoreDataHandler alloc] initWithStoreURL:storeURL modelURL:modelURL];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
