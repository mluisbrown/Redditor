//
//  RCCommentCell.h
//  Redditor
//
//  Created by Michael Brown on 06/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import UIKit;

@interface RCCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeadingConstraint;
@end
