

#import "UsergeekSessionTrackerState.h"
#import "UsergeekSessionTracker.h"

@implementation UsergeekSessionTrackerState

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker {
    self = [super init];
    if (self) {
        self.sessionTracker = sessionTracker;
    }
    return self;
}

- (id <UsergeekSessionTrackerState>)toBackground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer {
    NSAssert(NO, @"Must be overriden!");
    return nil;
}

- (id <UsergeekSessionTrackerState>)toForeground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer {
    NSAssert(NO, @"Must be overriden!");
    return nil;
}

- (id <UsergeekSessionTrackerState>)sessionExpirationEventOn:(id <UsergeekSessionTrackerState>)state listener:(UsergeekSessionTrackerListener *)listener {
    NSAssert(NO, @"Must be overriden!");
    return nil;
}

@end