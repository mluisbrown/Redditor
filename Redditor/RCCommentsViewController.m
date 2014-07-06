//
//  RCCommentViewController.m
//  Redditor
//
//  Created by Michael Brown on 06/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "RCCommentsViewController.h"
#import "RCCommentCell.h"

@interface RCCommentsViewController ()
@property (nonatomic, strong) NSArray *comments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation RCCommentsViewController

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
    
    [[RCModel sharedInstance] loadCommentsForLink:self.link completionHandler:^(NSArray *comments) {
        [self.activityView stopAnimating];
        self.comments = comments;
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
    if (!self.comments) {
        return 0;
    }
    
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    RCComment *comment = self.comments[indexPath.row];
    cell.textView.text = comment.body;
    cell.textView.scrollEnabled = NO;
    
    cell.textViewLeadingConstraint.constant = comment.indent * 5;
    
    return cell;
}

#pragma mark - UITableViewDelegate protocol

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCComment *comment = self.comments[indexPath.row];

    CGFloat textViewWidth = tableView.frame.size.width - comment.indent * 5;
    
    UITextView *temp = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, textViewWidth, CGFLOAT_MAX)];
    temp.text = comment.body;
    CGSize size = [temp sizeThatFits:temp.frame.size];
    
    return ceilf(size.height) + 5;
}


@end
