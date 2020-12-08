

#import <Foundation/Foundation.h>

typedef void (^UsergeekSessionTrackerListenerSessionStartedCallback)(BOOL firstSession);

typedef void (^UsergeekSessionTrackerListenerSessionEndedCallback)(NSTimeInterval duration);

typedef void (^UsergeekSessionTrackerListenerAppDidEnterBackgroundCallback)();

typedef void (^UsergeekSessionTrackerListenerAppWillTerminateCallback)();

@interface UsergeekSessionTrackerListener : NSObject

@property(nonatomic, copy) UsergeekSessionTrackerListenerSessionStartedCallback sessionStartedCallback;
@property(nonatomic, copy) UsergeekSessionTrackerListenerSessionEndedCallback sessionEndedCallback;
@property(nonatomic, copy) UsergeekSessionTrackerListenerAppDidEnterBackgroundCallback appDidEnterBackgroundCallback;
@property(nonatomic, copy) UsergeekSessionTrackerListenerAppWillTerminateCallback appWillTerminateCallback;

+ (instancetype)listenerWithSessionStartedCallback:(UsergeekSessionTrackerListenerSessionStartedCallback)sessionStartedCallback
                              sessionEndedCallback:(UsergeekSessionTrackerListenerSessionEndedCallback)sessionEndedCallback
                     appDidEnterBackgroundCallback:(UsergeekSessionTrackerListenerAppDidEnterBackgroundCallback)appDidEnterBackgroundCallback
                          appWillTerminateCallback:(UsergeekSessionTrackerListenerAppWillTerminateCallback)appWillTerminateCallback;

@end