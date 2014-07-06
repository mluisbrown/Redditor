//
//  RedditorTests.m
//  RedditorTests
//
//  Created by Michael Brown on 04/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

@import XCTest;

#import "AsyncTests.h"
#import "RCModel.h"

@interface RedditorTests : XCTestCase

@end

@implementation RedditorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testModelLoad {
    RCModel *model = [[RCModel alloc] init];
    
    StartBlock();
    
    [model loadLinksAfter:nil before:nil completionHandler:^(NSArray *links) {
        EndBlock();
        XCTAssertNotNil(links);
    }];
    
    // Run the Wait loop
    WaitUntilBlockCompletes();
}

- (void) testLoadComments {
    RCModel *model = [[RCModel alloc] init];
    
    StartBlock();
    
    [model loadLinksAfter:nil before:nil completionHandler:^(NSArray *links) {
        RCLink *link = [links firstObject];
        
        [model loadCommentsForLink:link completionHandler:^(NSArray *comments) {
            EndBlock();
            XCTAssertNotNil(comments);
        }];
    }];
    
    // Run the Wait loop
    WaitUntilBlockCompletes();
}

@end
