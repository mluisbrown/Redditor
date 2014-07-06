//
//  RCCommentViewController.h
//  Redditor
//
//  Created by Michael Brown on 06/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import UIKit;
#import "RCLink.h"
#import "RCModel.h"
#import "RCComment.h"

@interface RCCommentsViewController : UITableViewController
@property (nonatomic, strong) RCLink *link;
@end
