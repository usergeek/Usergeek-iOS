

#import <Foundation/Foundation.h>

@class UsergeekSessionTracker;
@class UsergeekSessionTrackerListener;

@protocol UsergeekSessionTrackerState <NSObject>
- (id <UsergeekSessionTrackerState>)toBackground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer;

- (id <UsergeekSessionTrackerState>)toForeground:(UsergeekSessionTrackerListener *)listener timer:(NSTimer *)timer;

- (id <UsergeekSessionTrackerState>)sessionExpirationEventOn:(id <UsergeekSessionTrackerState>)state listener:(UsergeekSessionTrackerListener *)listener;
@end

@interface UsergeekSessionTrackerState : NSObject <UsergeekSessionTrackerState>

@property(nonatomic, weak) UsergeekSessionTracker *sessionTracker;

- (instancetype)initWithTracker:(UsergeekSessionTracker *)sessionTracker;

@end