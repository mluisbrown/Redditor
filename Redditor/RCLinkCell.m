//
//  RCLinkCell.m
//  Redditor
//
//  Created by Michael Brown on 05/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "RCLinkCell.h"

@implementation RCLinkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
