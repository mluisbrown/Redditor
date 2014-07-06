//
//  RCModel.h
//  Redditor
//
//  Created by Michael Brown on 04/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import Foundation;

@class RCLink;

@interface RCModel : NSObject
+ (instancetype) sharedInstance;
- (void) loadLinksAfter:(RCLink *) after before:(RCLink *) before completionHandler:(void (^)(NSArray *links))completionHandler;
- (void) loadCommentsForLink:(RCLink *) link completionHandler:(void (^)(NSArray *comments))completionHandler;

@end
