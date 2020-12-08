

#import "UsergeekSessionTrackerBackgroundState.h"
#import "UsergeekSessionTrackerListener.h"
#import "UsergeekUtils.h"
#import "UsergeekSessionTrackerSessionForegroundState.h"

@interface UsergeekSessionTrackerBackgroundState ()
@property(nonatomic, readwrite) BOOL coldStart;
@end

@implementation UsergeekSessionTrackerBackgroundState

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker coldStart:(BOOL)coldStart {
    self = [super initWithTracker:sessionTracker];
    if (self) {
        self.coldStart = coldStart;
    }
    return self;
}

- (id <UsergeekSessionTrackerState>)toForeground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer {
    NSTimeInterval startSession = [UsergeekUtils systemUptime];
    [timer invalidate];

    listener.sessionStartedCallback(_coldStart);
    return [[UsergeekSessionTrackerSessionForegroundState alloc] initWithTracker:self.sessionTracker startSession:startSession];
}

@end
