//
//  RCDetailViewController.m
//  Redditor
//
//  Created by Michael Brown on 06/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "RCDetailViewController.h"
#import "RCCommentsViewController.h"



@interface RCDetailViewController ()

@end

@implementation RCDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView.delegate = self;
    
    if (self.link.selfReddit) {
        self.webView.scalesPageToFit = NO;
        self.actionButton.enabled = NO;
        [self.webView loadHTMLString:self.link.selfText baseURL:nil];
    } else {
        NSURL *url = [NSURL URLWithString:self.link.url];
        
        // make sure that direct image links are properly sized to fit the webview
        if ([@"jpg jpeg gif tif tiff png" rangeOfString:url.pathExtension options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSString *htmlString = [NSString stringWithFormat:@"<img style=\"width:100%%\" src=\"%@\"/>", self.link.url];
            [self.webView loadHTMLString:htmlString baseURL:nil];
            self.actionButton.enabled = NO;
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
            self.actionButton.enabled = YES;
        }
        
        self.webView.scalesPageToFit = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTapped:(UIBarButtonItem *)sender {
    self.forwardButton.enabled = YES;
    [self.webView goBack];
}

- (IBAction)forwardButtonTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender {
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles:@"Open in Safari", nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
    [popupQuery showInView:self.webView];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // unwrap the controller if it's embedded in the nav controller.
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers firstObject];
    } else {
        controller = segue.destinationViewController;
    }
    
    // set the link in the comment view controller
    if ([controller isKindOfClass:[RCCommentsViewController class]]) {
        RCCommentsViewController *vc = (RCCommentsViewController *)controller;
        vc.link = self.link;
    } else {
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        self.backButton.enabled = YES;
    }
    
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		// open in Safari
		NSURL *webURL = [NSURL URLWithString:self.webView.request.URL.absoluteString];
        
		[[UIApplication sharedApplication] openURL:webURL];
	}
}

@end
