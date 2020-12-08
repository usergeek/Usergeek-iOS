

#import <Foundation/Foundation.h>
#import "UsergeekSessionTrackerState.h"

@interface UsergeekSessionTrackerSessionForegroundState : UsergeekSessionTrackerState
@property(nonatomic, readonly) NSTimeInterval startSession;

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker startSession:(NSTimeInterval)startSession;
@end