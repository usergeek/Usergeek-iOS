

#import "UsergeekSessionTrackerSessionBackgroundState.h"
#import "UsergeekUtils.h"
#import "UsergeekSessionTracker.h"
#import "UsergeekSessionTrackerSessionForegroundState.h"
#import "UsergeekSessionTrackerBackgroundState.h"

@interface UsergeekSessionTrackerSessionBackgroundState ()
@property(nonatomic, readwrite) NSTimeInterval startSession;
@property(nonatomic, readwrite) NSTimeInterval startBackground;
@property(nonatomic) NSTimer *timer;
@property(nonatomic) NSTimeInterval timeout;
@end

@implementation UsergeekSessionTrackerSessionBackgroundState

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker startSession:(NSTimeInterval)startSession startBackground:(NSTimeInterval)startBackground {
    self = [super initWithTracker:sessionTracker];
    if (self) {
        self.timeout = 30.0f;
        self.startSession = startSession;
        self.startBackground = startBackground;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(onTimerFired:) userInfo:nil repeats:NO];
    }
    return self;
}

- (id <UsergeekSessionTrackerState>)toForeground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer {
    NSTimeInterval time = [UsergeekUtils systemUptime];

    [self.timer invalidate];
    self.timer = nil;

    if ((time - _startBackground) < self.timeout) {
        return [[UsergeekSessionTrackerSessionForegroundState alloc] initWithTracker:self.sessionTracker startSession:self.startSession];
    } else {
        listener.sessionEndedCallback(self.startBackground - self.startSession);
        listener.sessionStartedCallback(NO);
        return [[UsergeekSessionTrackerSessionForegroundState alloc] initWithTracker:self.sessionTracker startSession:time];
    }
}

- (id <UsergeekSessionTrackerState>)sessionExpirationEventOn:(id <UsergeekSessionTrackerState>)state listener:(UsergeekSessionTrackerListener *)listener {
    if (state == self) {
        listener.sessionEndedCallback(self.startBackground - self.startSession);
        return [[UsergeekSessionTrackerBackgroundState alloc] initWithTracker:self.sessionTracker coldStart:NO];
    }
    return self;
}

#pragma mark Internal

- (void)onTimerFired:(NSTimer *)timer {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUsergeekSessionTrackerSessionExpiredNotification object:self];
}

@end
