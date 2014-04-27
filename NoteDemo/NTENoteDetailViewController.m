//
//  NTENoteDetailViewController.m
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import "NTENoteDetailViewController.h"

// Models
#import "NTENote.h"

// Handlers
#import "NTEHandlerProvider.h"
#import "NTECoreDataHandler.h"
#import "NTENoteHandler.h"

@interface NTENoteDetailViewController ()

@end

@implementation NTENoteDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _noteDetailViewMode = NTENilDetailViewMode;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - view lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // configure the view based on the current mode
    [self configureNoteDetailView];
    
    // fix default content inset
    self.bodyTextView.contentInset = UIEdgeInsetsMake(0,-4,0,-4);
}

- (void)viewWillDisappear:(BOOL)animated {
    switch (self.noteDetailViewMode) {
        case NTENewNoteDetailViewMode:
            [self saveNewNote];
            break;
            
        case NTEViewNoteDetailViewMode:
            break;
            
        case NTEEditDetailViewMode:
            break;
            
        case NTENilDetailViewMode:
            break;
    }
}

#pragma mark - note detail view mode handling

- (void)configureNoteDetailView {
    NSAssert(self.noteDetailViewMode != NTENilDetailViewMode, @"Trying to load note detail view loaded without the mode being set");
    
    [self configureNavigationItems];
}

- (void)configureNavigationItems {
    switch (self.noteDetailViewMode) {
        case NTENewNoteDetailViewMode:
            // nothing needed
            break;
            
        case NTEViewNoteDetailViewMode:
            break;
            
        case NTEEditDetailViewMode:
            break;
            
        default:
            break;
    }
}

#pragma mark - new mode methods

- (void)saveNewNote {
    NSString *trimmedTitle = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedBody = [self.bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // don't create new note if there is no text
    if ([trimmedTitle isEqualToString:@""] && [trimmedBody isEqualToString:@""]) {
        return;
    }
    
    // set default title if needed
    if ([trimmedTitle isEqualToString:@""]) {
        trimmedTitle = [NSString stringWithFormat:@"New Note"];
    }
    
    // create new note
    [[NTEHandlerProvider noteHandler] newNoteWithTitle:trimmedTitle
                                                 body:trimmedBody
                               inManagedObjectContext:[[NTEHandlerProvider coreDataHandler] managedObjectContext]];
    
    // save the managed object context
    [[NTEHandlerProvider coreDataHandler] saveManagedObjectContext];
}

#pragma mark - text view delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.tapToEditLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    // hide tap to edit label if user input text
    if (textView.text.length > 0) {
        self.tapToEditLabel.hidden = YES;
    }
    else {
        self.tapToEditLabel.hidden = NO;
    }
}

@end
