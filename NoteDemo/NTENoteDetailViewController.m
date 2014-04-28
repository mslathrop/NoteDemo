//
//  NTENoteDetailViewController.m
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import "NTENoteDetailViewController.h"

// Handlers
#import "NTEHandlerProvider.h"

// Libraries
#import "Flurry.h"

// Models
#import "NTENote.h"

@interface NTENoteDetailViewController ()

@property (nonatomic, assign, getter = isSaveNeeded) BOOL saveNeeded;

@end

@implementation NTENoteDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _noteDetailViewMode = NTENilDetailViewMode;
        _saveNeeded = NO;
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
    self.bodyTextView.contentInset = UIEdgeInsetsMake(-10,-4,0,-4);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // saving the context here eliminates lag in the ui
    if (self.isSaveNeeded) {
        [[NTEHandlerProvider coreDataHandler] saveManagedObjectContext];
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
        case NTEViewNoteDetailViewMode:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                                   target:self
                                                                                                   action:@selector(actionButtonTapped:)];
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
    
    self.saveNeeded = YES;
    
    // set default title if needed
    if ([trimmedTitle isEqualToString:@""]) {
        trimmedTitle = [NSString stringWithFormat:@"Untitled"];
    }
    
    // create new note
    [[NTEHandlerProvider noteHandler] newNoteWithTitle:trimmedTitle
                                                  body:trimmedBody
                                inManagedObjectContext:[[NTEHandlerProvider coreDataHandler] managedObjectContext]];
}

#pragma mark - view mode methods

- (void)saveExistingNote {
    // return if user didn't change anything
    if ([self.existingNote.title isEqualToString:self.titleTextField.text] && [self.existingNote.body isEqualToString:self.bodyTextView.text]) {
        return;
    }
    
    self.saveNeeded = YES;
    
    NSString *trimmedTitle = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedBody = [self.bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // delete note if both fields are blank
    if ([trimmedTitle isEqualToString:@""] && [trimmedBody isEqualToString:@""]) {
        [[NTEHandlerProvider noteHandler] deleteNote:self.existingNote inManagedObjectContext:[[NTEHandlerProvider coreDataHandler] managedObjectContext]];
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
    
    // track edit in flurry
    [Flurry logEvent:@"Note_Edited"];
}

- (void)actionButtonTapped:(id)sender {
    // there is a log sometimes when opening the activity view controller. this will account for that
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    self.navigationItem.rightBarButtonItem.customView = activityIndicator;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSString stringWithFormat:@"%@:\n\n%@",
                                                                                                                      self.titleTextField.text,
                                                                                                                      self.bodyTextView.text]]
                                                                                             applicationActivities:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.navigationItem.rightBarButtonItem.customView = nil;
            [self.navigationController presentViewController:activityViewController
                                                    animated:YES
                                                  completion:^{}];
        });
    });
}

#pragma mark - text view delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.tapToEditLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self hideTapToEditLabelIfNeeded];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self showTextViewCaretPosition:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self showTextViewCaretPosition:textView];
}

- (void)showTextViewCaretPosition:(UITextView *)textView {
    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
    [textView scrollRectToVisible:caretRect animated:NO];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat keyboardHeight = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
    
    UIEdgeInsets contentInset = self.bodyTextView.contentInset;
    contentInset.bottom = keyboardHeight;
    
    
    UIEdgeInsets scrollIndicatorInsets = self.bodyTextView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = keyboardHeight;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.bodyTextView.contentInset = contentInset;
        self.bodyTextView.scrollIndicatorInsets = scrollIndicatorInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIEdgeInsets contentInset = self.bodyTextView.contentInset;
    contentInset.bottom = 0;
    
    UIEdgeInsets scrollIndicatorInsets = self.bodyTextView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = 0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.bodyTextView.contentInset = contentInset;
        self.bodyTextView.scrollIndicatorInsets = scrollIndicatorInsets;
    }];
}

#pragma mark - other methods

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self showTextViewCaretPosition:self.bodyTextView];
}

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
