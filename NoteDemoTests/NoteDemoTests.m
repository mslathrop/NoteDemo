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
#import "NTENoteHandler.h"
#import "NTENote.h"

// Other
#import "NTEConstants.h"

@interface NoteDemoTests : XCTestCase

@property (strong, nonatomic) id<NTECoreDataHandlerProtocol> coreDataHandler;
@property (strong, nonatomic) id<NTENoteHandlerProtocol> noteHandler;

@end

@implementation NoteDemoTests

- (void)setUp
{
    [super setUp];
    
    [self resetCoreDataStack];
    [self setupCoreDataHandler];
    self.noteHandler = [[NTENoteHandler alloc] init];
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

#pragma mark - note model tests
- (void)testInsertAndRetrieveNewNote {
    NSString *title = @"test";
    NSString *body = @"test";
    
    NTENote *note = [self.noteHandler newNoteWithTitle:title body:body inManagedObjectContext:[self.coreDataHandler managedObjectContext]];
    [self.coreDataHandler saveManagedObjectContext];
    
    NTENote *retrieved = [self.noteHandler retrieveNoteWithEntityId:note.entityId inManagedObjectContext:[self.coreDataHandler managedObjectContext]];
    
    XCTAssertNotNil(retrieved, @"retrieved is nil");
    XCTAssertNotNil(note.createdAt, @"createdAt is nil");
    XCTAssertNotNil(note.modifiedAt, @"modifiedAt is nil");
    XCTAssertEqual(note.title, title, @"title was not saved correctly");
    XCTAssertEqual(note.body, body, @"body was not saved correctly");
}

- (void)testDeleteNote {
    NSString *title = @"test";
    NSString *body = @"test";
    
    // add the note
    NTENote *note = [self.noteHandler newNoteWithTitle:title body:body inManagedObjectContext:[self.coreDataHandler managedObjectContext]];
    [self.coreDataHandler saveManagedObjectContext];
    
    // retrive it
    NTENote *retrieved = [self.noteHandler retrieveNoteWithEntityId:note.entityId inManagedObjectContext:[self.coreDataHandler managedObjectContext]];
    XCTAssertNotNil(retrieved, @"retrieved is nil");
    XCTAssertNotNil(note.createdAt, @"createdAt is nil");
    XCTAssertNotNil(note.modifiedAt, @"modifiedAt is nil");
    XCTAssertEqual(note.title, title, @"title was not saved correctly");
    XCTAssertEqual(note.body, body, @"body was not saved correctly");
    
    // delete it
    [self.noteHandler deleteNote:retrieved inManagedObjectContext:[self.coreDataHandler managedObjectContext]];
    [self.coreDataHandler saveManagedObjectContext];
    
    // retrive it
    retrieved = [self.noteHandler retrieveNoteWithEntityId:note.entityId inManagedObjectContext:[self.coreDataHandler managedObjectContext]];
    XCTAssertNil(retrieved, @"retrieved was not nil");
}

#pragma mark - helper methods

- (void)setupCoreDataHandler {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kNTECoreDataModelName withExtension:@"momd"];
    self.coreDataHandler = [[NTECoreDataHandler alloc] initWithStoreURL:[self testStoreURL] modelURL:modelURL isiCloudEnabled:NO];
}

- (void)resetCoreDataStack {
    NSError *error = nil;
    [self.coreDataHandler.persistentStoreCoordinator removePersistentStore:self.coreDataHandler.persistentStoreCoordinator.persistentStores[0] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[[self testStoreURL] path] error:&error];
    self.coreDataHandler = nil;
}

- (NSURL *)testStoreURL {
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    
    return [documentsDirectory URLByAppendingPathComponent:kNTECoreDataStoreTestName];
}

@end
