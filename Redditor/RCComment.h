//
//  RCComment.h
//  Redditor
//
//  Created by Michael Brown on 05/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import Foundation;

@interface RCComment : NSObject

@property (nonatomic, strong) NSString *idkey;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *bodyHTML;
@property (nonatomic, assign) NSUInteger indent;

@end
