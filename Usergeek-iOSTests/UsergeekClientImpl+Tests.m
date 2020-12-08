#import "UsergeekClientImpl+Tests.h"
#import "UsergeekIdentifyStorage.h"
#import "UsergeekReportsStorage.h"
#import "UsergeekConfiguration.h"

@implementation UsergeekClientImpl (Tests)

@dynamic deviceId;
@dynamic userId;
@dynamic configuration;
@dynamic identifyStorage;
@dynamic reportsStorage;
@dynamic operationQueue;

- (void) waitUntilAllOperationsAreFinished {
    [self.operationQueue waitUntilAllOperationsAreFinished];
}

@end
