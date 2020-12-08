

#import <Foundation/Foundation.h>
#import "UsergeekSessionTrackerState.h"

@interface UsergeekSessionTrackerSessionBackgroundState : UsergeekSessionTrackerState

@property(nonatomic, readonly) NSTimeInterval startSession;
@property(nonatomic, readonly) NSTimeInterval startBackground;

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker startSession:(NSTimeInterval)startSession startBackground:(NSTimeInterval)startBackground;

@end