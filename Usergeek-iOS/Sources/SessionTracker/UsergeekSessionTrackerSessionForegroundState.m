

#import "UsergeekSessionTrackerSessionForegroundState.h"
#import "UsergeekUtils.h"
#import "UsergeekSessionTrackerSessionBackgroundState.h"
#import "UsergeekSessionTrackerListener.h"

@interface UsergeekSessionTrackerSessionForegroundState ()
@property(nonatomic, readwrite) NSTimeInterval startSession;
@end

@implementation UsergeekSessionTrackerSessionForegroundState

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker startSession:(NSTimeInterval)startSession {
    self = [super initWithTracker:sessionTracker];
    if (self) {
        self.startSession = startSession;
    }
    return self;
}

- (id <UsergeekSessionTrackerState>)toBackground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer {
    listener.appDidEnterBackgroundCallback();
    NSTimeInterval time = [UsergeekUtils systemUptime];
    return [[UsergeekSessionTrackerSessionBackgroundState alloc] initWithTracker:self.sessionTracker startSession:self.startSession startBackground:time];
}

- (id <UsergeekSessionTrackerState>)toForeground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer {
    //do nothing. this may happen e.g. after siri is closed
    return self;
}
@end
