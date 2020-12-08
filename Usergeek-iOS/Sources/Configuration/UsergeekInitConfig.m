

#import "UsergeekInitConfig.h"

@implementation UsergeekInitConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionTimeout = 30.0f;
        self.uploadTimeout = 60.0f;
        self.uploadReportsCount = 30;
        self.uploadReportsPeriod = 30.0f;
    }
    return self;
}

@end