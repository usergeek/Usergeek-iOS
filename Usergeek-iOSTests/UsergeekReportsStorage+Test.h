

#import <Foundation/Foundation.h>
#import "UsergeekReportsStorage.h"

@interface UsergeekReportsStorage (Test)

@property(nonatomic, readonly) dispatch_queue_t databaseOperationQueue;

- (void) waitUntilAllOperationsAreFinished;

@end