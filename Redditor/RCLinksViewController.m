//
//  RCLinksViewController.m
//  Redditor
//
//  Created by Michael Brown on 05/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "RCLinksViewController.h"
#import "RCModel.h"
#import "RCLink.h"
#import "RCLinkCell.h"
#import "RCDetailViewController.h"
#import "UIImageView+LCAsyncLoad.h"

@interface RCLinksViewController ()
@property (nonatomic, strong) NSArray *links;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation RCLinksViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.activityView startAnimating];

    [[RCModel sharedInstance] loadLinksAfter:nil before:nil completionHandler:^(NSArray *links) {
        [self.activityView stopAnimating];
        self.links = links;
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.links) {
        return 0;
    }
    
    return self.links.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell" forIndexPath:indexPath];
    
    // Configure the cell...
    RCLink *link = self.links[indexPath.row];
    cell.textView.text = link.title;
    cell.textView.scrollEnabled = NO;
    
    cell.infoLabel.text = [NSString stringWithFormat:@"%@ • %d", link.subreddit, link.ups];
    if ([link.thumbnailUrl length]) {
        [cell.thumbnail setImageWithURL:[NSURL URLWithString:link.thumbnailUrl]];
    } else {
        cell.thumbnail.image = [UIImage imageNamed:@"reddit"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCLink *link = self.links[indexPath.row];
    
    UITextView *temp = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 107, CGFLOAT_MAX)];
    temp.text = link.title;
    CGSize size = [temp sizeThatFits:temp.frame.size];
    
    return MAX(ceilf(size.height) + 25, 74);
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
    
    // set the link in the detail view controller
    if ([controller isKindOfClass:[RCDetailViewController class]]) {
        RCDetailViewController *vc = (RCDetailViewController *)controller;
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        vc.link = self.links[ip.row];
    } else {
        NSAssert(NO, @"Unknown segue. All segues must be handled.");
    }
    
}

@end
