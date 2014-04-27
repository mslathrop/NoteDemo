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
    [super viewWillDisappear:animated];
    
    switch (self.noteDetailViewMode) {
        case NTENewNoteDetailViewMode:
            [self saveNewNote];
            break;
            
        case NTEViewNoteDetailViewMode:
            [self saveExistingNote];
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
    [self configureTextControls];
}

- (void)configureNavigationItems {
    switch (self.noteDetailViewMode) {
        case NTEEditDetailViewMode:
            break;
            
        default:
            break;
    }
}

- (void)configureTextControls {
    switch (self.noteDetailViewMode) {
        case NTEViewNoteDetailViewMode:
            self.titleTextField.text = self.existingNote.title;
            self.bodyTextView.text = self.existingNote.body;
            break;
            
        default:
            break;
    }
    
    [self hideTapToEditLabelIfNeeded];
}

#pragma mark - new mode methods

- (void)saveNewNote {
    NSString *trimmedTitle = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedBody = [self.bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // don't create new note if there isn't text
    if ([trimmedTitle isEqualToString:@""] && [trimmedBody isEqualToString:@""]) {
        return;
    }
    
    // set default title if needed
    if ([trimmedTitle isEqualToString:@""]) {
        trimmedTitle = [NSString stringWithFormat:@"Untitled"];
    }
    
    // create new note
    [[NTEHandlerProvider noteHandler] newNoteWithTitle:trimmedTitle
                                                  body:trimmedBody
                                inManagedObjectContext:[[NTEHandlerProvider coreDataHandler] managedObjectContext]];
    
    // save the managed object context
    [[NTEHandlerProvider coreDataHandler] saveManagedObjectContext];
}

#pragma mark - view mode methods

- (void)saveExistingNote {
    // return if user didn't change anything
    if ([self.existingNote.title isEqualToString:self.titleTextField.text] && [self.existingNote.body isEqualToString:self.bodyTextView.text]) {
        return;
    }
    
    NSString *trimmedTitle = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedBody = [self.bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // delete note if both fields are blank
    if ([trimmedTitle isEqualToString:@""] && [trimmedBody isEqualToString:@""]) {
        [[NTEHandlerProvider noteHandler] deleteNote:self.existingNote inManagedObjectContext:[[NTEHandlerProvider coreDataHandler] managedObjectContext]];
        [[NTEHandlerProvider coreDataHandler] saveManagedObjectContext];
        return;
    }
    
    // set default title if needed
    if ([trimmedTitle isEqualToString:@""]) {
        trimmedTitle = [NSString stringWithFormat:@"Untitled"];
    }
    
    // update the note
    self.existingNote.title = trimmedTitle;
    self.existingNote.body = trimmedBody;
    self.existingNote.modifiedAt = [NSDate date];
    
    // save the managed object context
    [[NTEHandlerProvider coreDataHandler] saveManagedObjectContext];
}

- (void)editButtonWasTapped:(id)sender {
    
}


#pragma mark - edit mode methods


#pragma mark - text view delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.tapToEditLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self hideTapToEditLabelIfNeeded];
}

#pragma mark - other methods

- (void)hideTapToEditLabelIfNeeded {
    // hide tap to edit label if user input text
    if (self.bodyTextView.text.length > 0) {
        self.tapToEditLabel.hidden = YES;
    }
    else {
        self.tapToEditLabel.hidden = NO;
    }
}

@end
