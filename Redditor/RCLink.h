//
//  RCThing.h
//  Redditor
//
//  Created by Michael Brown on 04/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import Foundation;

@interface RCLink : NSObject

@property (nonatomic, strong) NSString *idkey;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *subreddit;
@property (nonatomic, assign) NSUInteger ups;
@property (nonatomic, assign) NSUInteger numComments;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *selfText;
@property (nonatomic, strong) NSString *selfTextHTML;
@property (nonatomic, assign) BOOL selfReddit;

@end
