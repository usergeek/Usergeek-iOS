

#import "UsergeekReportsStorage+Test.h"

@implementation UsergeekReportsStorage (Test)

@dynamic databaseOperationQueue;

- (void)waitUntilAllOperationsAreFinished {
    dispatch_sync(self.databaseOperationQueue, ^{

    });
}

@end