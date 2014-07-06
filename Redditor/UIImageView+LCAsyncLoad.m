//
//  UIImageView+LCAsyncLoad.m
//  Redditor
//
//  Created by Michael Brown on 06/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#import "UIImageView+LCAsyncLoad.h"

@implementation UIImageView (LCAsyncLoad)

+ (NSURLSession *) sharedURLSession {
    static NSURLSession *urlSession = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        urlSession = [NSURLSession sessionWithConfiguration:config];
    });
    
    return urlSession;
}


- (void) setImageWithURL:(NSURL *) url {
    self.image = [UIImage imageNamed:@"reddit"];
    
    __weak __typeof(self)weakSelf = self;
    
    NSURLSessionDataTask *task = [[UIImageView sharedURLSession] dataTaskWithURL:url
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (error == nil && data != nil) {
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.image = image;
                });
            }
        }];
    
    [task resume];
}

@end
