//
//  AsyncTests.h
//  Redditor
//
//  Created by Michael Brown on 04/07/2014.
//  Copyright (c) 2014 Michael Brown. All rights reserved.
//

#ifndef Redditor_AsyncTests_h
#define Redditor_AsyncTests_h

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
} \
} while(0)

#endif
