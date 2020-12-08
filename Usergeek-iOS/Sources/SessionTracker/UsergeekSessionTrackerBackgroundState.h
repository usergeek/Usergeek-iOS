

#import <Foundation/Foundation.h>
#import "UsergeekSessionTrackerState.h"

@interface UsergeekSessionTrackerBackgroundState : UsergeekSessionTrackerState
@property(nonatomic, readonly) BOOL coldStart;

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker coldStart:(BOOL)coldStart;

@end