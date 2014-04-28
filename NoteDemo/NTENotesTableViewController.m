//
//  NTENotesTableViewController.m
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import "NTENotesTableViewController.h"

// Controllers
#import "NTENoteDetailViewController.h"

// Handlers
#import "NTEHandlerProvider.h"

// Models
#import "NTENote.h"

// Other
#import "NTEConstants.h"

// Views
#import "NTENoteTableViewCell.h"

@interface NTENotesTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NTENotesTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _managedObjectContext = [[NTEHandlerProvider coreDataHandler] managedObjectContext];
    }
    return self;
}

#pragma mark - view lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set nav bar appearance
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:180.0/255.0 blue:1.0 alpha:0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // perfrom fetch of data
    [self reloadFetchResults];
}

#pragma mark - table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ruid_noteCell";
    NTENoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTENote *selectedNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[NTEHandlerProvider noteHandler] deleteNote:selectedNote inManagedObjectContext:[[NTEHandlerProvider coreDataHandler] managedObjectContext]];
    [[NTEHandlerProvider coreDataHandler] saveManagedObjectContext];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kNTENoteTableViewCellHeight;
}

#pragma mark - cell drawing methods

- (void)configureCell:(NTENoteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NTENote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextField.text = note.title;
    cell.bodyTextField.text = note.body;
}

#pragma mark - fetched results controller delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(NTENoteTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - fetched results controller methods

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        
        // set up fetch request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NTENote entityInManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // sort notes by last updated
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"modifiedAt" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        [fetchRequest setFetchBatchSize:20];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"allNotesFRCCache"];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void)reloadFetchResults {
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"The All Notes fetched results controller encountered an error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"seg_addNote"]) {
        NTENoteDetailViewController *viewController = segue.destinationViewController;
        viewController.noteDetailViewMode = NTENewNoteDetailViewMode;
    }
    else if ([segue.identifier isEqualToString:@"seg_viewNote"]) {
        NTENote *selectedNote = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        
        NTENoteDetailViewController *viewController = segue.destinationViewController;
        viewController.noteDetailViewMode = NTEViewNoteDetailViewMode;
        viewController.existingNote = selectedNote;
    }
}

@end
