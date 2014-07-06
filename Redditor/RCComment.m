//
//  RCComment.m
//  Redditor
//
//  Created by Michael Brown on 05/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "RCComment.h"

@implementation RCComment

- (NSString *) description {
    return [NSString stringWithFormat:@"name: %@, indent: %d", self.name, self.indent];
}

@end
