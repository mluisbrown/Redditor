//
//  RCModel.m
//  Redditor
//
//  Created by Michael Brown on 04/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "RCModel.h"
#import "RCLink.h"
#import "RCComment.h"


static NSString *redditAPIFrontPageURLString = @"http://www.reddit.com/.json";
static NSString *redditAPICommentsURLString = @"http://www.reddit.com/comments/%@.json";

static NSString *kRCKindComment = @"t1";
static NSString *kRCKindLink = @"t3";
static NSString *kRCKindMore = @"more";


@interface RCModel ()
@property (nonatomic, strong) NSURLSession *urlSession;
@end

@implementation RCModel

+ (instancetype) sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype) init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

- (void) loadLinksAfter:(RCLink *) after before:(RCLink *) before completionHandler:(void (^)(NSArray *links))completionHandler {
    NSURL *baseURL = [NSURL URLWithString:redditAPIFrontPageURLString];
    NSString *urlParams = @"";
    // can only have either after or before param
    // after param will take precedence if both are passed in
    if (after || before) {
        urlParams = [NSString stringWithFormat:@"?%@=%@", after ? @"after" : @"before", after ? after.name : before.name];
    }
    
    NSURL *loadURL = [NSURL URLWithString:urlParams relativeToURL:baseURL];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:loadURL
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSMutableArray *links = nil;
            
            if (error == nil && data != nil) {
                id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([jsonDict respondsToSelector:@selector(objectForKey:)]) {
                    NSDictionary *dataDict = [jsonDict objectForKey:@"data"];
                    
                    if (dataDict) {
                        NSArray *children = dataDict[@"children"];
                        
                        links = [[NSMutableArray alloc] initWithCapacity:children.count];
                        
                        [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            NSDictionary *child = obj;
                            NSDictionary *childData = child[@"data"];
                                                        
                            RCLink *link = [[RCLink alloc] init];
                            link.name = childData[@"name"];
                            link.idkey = childData[@"id"];
                            link.url = childData[@"url"];
                            link.selfText = childData[@"selftext"];
                            link.selfTextHTML = childData[@"selftext_html"];
                            link.title = childData[@"title"];
                            link.selfReddit = [childData[@"is_self"] boolValue];
                            link.ups = [childData[@"ups"] integerValue];
                            link.numComments = [childData[@"num_comments"] integerValue];
                            link.subreddit = childData[@"subreddit"];
                            
                            [links addObject:link];
                        }];
                    }
                }
            }
            
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(links ? [NSArray arrayWithArray:links] : nil);
                });
            }
        }];
    
    [task resume];
}

- (void) loadCommentsForLink:(RCLink *) link completionHandler:(void (^)(NSArray *comments))completionHandler {
    if (!link) {
        if (completionHandler) {
            completionHandler(nil);
        }
    }
    
    NSURL *loadURL = [NSURL URLWithString:[NSString stringWithFormat:redditAPICommentsURLString, link.idkey]];
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:loadURL
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSMutableArray *comments = nil;
            
            if (error == nil && data != nil) {
                id jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([jsonArray respondsToSelector:@selector(objectAtIndex:)]) {
                    NSDictionary *commentDict = nil;
                    // comments are the second dictionary in the return results
                    if ([jsonArray count] > 1) {
                        commentDict = [jsonArray objectAtIndex:1];
                    }
                    
                    if (commentDict) {
                        NSArray *children = commentDict[@"data"][@"children"];
                        
                        if (children) {
                            // note: children.count is onlly the number of top level comments
                            // but it's all we know about
                            comments = [[NSMutableArray alloc] initWithCapacity:children.count];
                            
                            // weak strong dance we need to do so that we
                            // can use the block recursively without creating a retain cycle
                            void (^traverseComments)(NSArray *, NSUInteger);
                            __weak __block void (^weakTraverseComments)(NSArray *, NSUInteger);
                            
                            weakTraverseComments = traverseComments = ^(NSArray *children, NSUInteger indent) {
                                [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    NSDictionary *child = obj;
                                    NSDictionary *childData = child[@"data"];
                                    
                                    if ([child[@"kind"] isEqualToString:kRCKindComment]) {
                                        RCComment *comment = [[RCComment alloc] init];
                                        comment.name = childData[@"name"];
                                        comment.idkey = childData[@"id"];
                                        comment.body = childData[@"body"];
                                        comment.bodyHTML = childData[@"body_html"];
                                        comment.indent = indent;
                                        
                                        [comments addObject:comment];

                                        if ([childData[@"replies"] respondsToSelector:@selector(objectForKey:)]) {
                                            NSArray *replyChildren = childData[@"replies"][@"data"][@"children"];
                                            if (replyChildren) {
                                                weakTraverseComments(replyChildren, indent + 1);
                                            }
                                        }
                                    }
                                }];
                            };
                            
                            traverseComments(children, 0);
                            
                        }
                    }
                }
            }
            
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(comments ? [NSArray arrayWithArray:comments] : nil);
                });
            }
        }];

    [task resume];
}

@end
