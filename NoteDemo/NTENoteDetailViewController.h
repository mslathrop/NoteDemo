//
//  NTENoteDetailViewController.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/26/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTENoteDetailViewController : UIViewController <UITextViewDelegate>

/**
 Describes the current view mode fo the note detail view
 */
typedef enum {
    NTENewNoteDetailViewMode,
    NTEViewNoteDetailViewMode,
    NTEEditDetailViewMode,
    NTENilDetailViewMode
} NTENoteDetailViewMode;

/**
 The current view mode of the note. This is used to determine what bar buttons
 need to be shown dependin
 */
@property NTENoteDetailViewMode noteDetailViewMode;


// IB properties /////////////////////////////////////////////////////////////////////////

/**
 Text field that displays the title of the note
 */
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

/**
 Text view that displays the body of the note
 */
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

/**
 Label that shows users where to tap in order to use 
 the body text view
 */
@property (weak, nonatomic) IBOutlet UILabel *tapToEditLabel;

@end
