//
//  NTECoreDataHandler.m
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import "NTECoreDataHandler.h"

// Others
#import "NTEConstants.h"

@interface NTECoreDataHandler ()

@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) NSURL *storeURL;
@property (strong, nonatomic) NSURL *modelURL;
@property (nonatomic, assign, getter = isiCloudEnabled) BOOL iCloudEnabled;

@end

@implementation NTECoreDataHandler

- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL isiCloudEnabled:(BOOL)isiCloudEnabled {
    self = [super init];
    
    if (self) {
        NSAssert(storeURL != nil, @"The store url cannot be nil");
        NSAssert(modelURL != nil, @"The model url cannot be nil");
        
        _storeURL = storeURL;
        _modelURL = modelURL;
        _iCloudEnabled = isiCloudEnabled;
    }
    
    return self;
}

#pragma mark - core data stack methods

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
        
        // configuration depending on whether iCloud is on or off
        // if current iCloud token is nil then that means user turned off iCloud in settings
        // and we should load up the local store
        NSDictionary *options = nil;
        if (currentiCloudToken && self.isiCloudEnabled) {
            // subscribe to iCloud notifications
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            [defaultCenter addObserver:self
                              selector:@selector(storesWillChange:)
                                  name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                object:_persistentStoreCoordinator];
            
            [defaultCenter addObserver:self
                              selector:@selector(storesDidChange:)
                                  name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                object:_persistentStoreCoordinator];
            
            [defaultCenter addObserver:self
                              selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                                  name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                object:_persistentStoreCoordinator];
            
            options = @{
                        NSMigratePersistentStoresAutomaticallyOption : @YES,
                        NSInferMappingModelAutomaticallyOption : @YES,
                        NSPersistentStoreUbiquitousContentNameKey : kNTECoreDataiCloudStoreName
                        };
        }
        else {
            options = @{
                        NSMigratePersistentStoresAutomaticallyOption : @YES,
                        NSInferMappingModelAutomaticallyOption : @YES
                        };
        }
        
        // add the store
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:self.storeURL
                                                             options:options
                                                               error:&error]) {
            NSLog(@"Error ocurred during creation of the persistentStoreCoordinator %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy; 
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    
    return _managedObjectModel;
}

- (void)saveManagedObjectContext {
    if ([self.managedObjectContext hasChanges]) {
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error occurred trying to save the managed object context %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - iCloud handling methods

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", notification);
    
    NSManagedObjectContext *context = self.managedObjectContext;
	
    [context performBlock:^{
        [context mergeChangesFromContextDidSaveNotification:notification];
    }];
}

- (void)storesWillChange:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", notification);
    
    NSManagedObjectContext *context = self.managedObjectContext;
	
    [context performBlockAndWait:^{
        NSError *error;
		
        if ([context hasChanges]) {
            BOOL success = [context save:&error];
            
            if (!success && error) {
                // perform error handling
                NSLog(@"%@",[error localizedDescription]);
            }
        }
        
        [context reset];
    }];
    
    // don't need to update anything at this moment as the fetched results delegate will handle this
}

- (void)storesDidChange:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", notification);
    
    // don't need to update anything at this moment as the fetched results delegate will handle this
}

@end
