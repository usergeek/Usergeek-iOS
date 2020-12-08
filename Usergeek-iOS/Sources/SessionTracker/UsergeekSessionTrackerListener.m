

#import "UsergeekSessionTrackerListener.h"

@implementation UsergeekSessionTrackerListener

+ (instancetype)listenerWithSessionStartedCallback:(UsergeekSessionTrackerListenerSessionStartedCallback)sessionStartedCallback
                              sessionEndedCallback:(UsergeekSessionTrackerListenerSessionEndedCallback)sessionEndedCallback
                     appDidEnterBackgroundCallback:(UsergeekSessionTrackerListenerAppDidEnterBackgroundCallback)appDidEnterBackgroundCallback
                          appWillTerminateCallback:(UsergeekSessionTrackerListenerAppWillTerminateCallback)appWillTerminateCallback {
    UsergeekSessionTrackerListener *sessionTrackerListener = [[self alloc] init];
    sessionTrackerListener.sessionStartedCallback = sessionStartedCallback;
    sessionTrackerListener.sessionEndedCallback = sessionEndedCallback;
    sessionTrackerListener.appDidEnterBackgroundCallback = appDidEnterBackgroundCallback;
    sessionTrackerListener.appWillTerminateCallback = appWillTerminateCallback;
    return sessionTrackerListener;
}

@end