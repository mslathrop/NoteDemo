//
//  NTENoteTableViewCell.h
//  NoteDemo
//
//  Created by Matthew Lathrop on 4/27/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTENoteTableViewCell : UITableViewCell

/**
 Displays the title of the note
 */
@property (weak, nonatomic) IBOutlet UILabel *titleTextField;

/**
 Displays one line preview of the body of the note
 */
@property (weak, nonatomic) IBOutlet UILabel *bodyTextField;

@end
