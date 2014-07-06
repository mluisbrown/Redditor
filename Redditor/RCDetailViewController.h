//
//  RCDetailViewController.h
//  Redditor
//
//  Created by Michael Brown on 06/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import UIKit;

#import "RCLink.h"

@interface RCDetailViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) RCLink *link;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
