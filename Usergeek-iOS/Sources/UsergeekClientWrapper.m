

#import "UsergeekClientWrapper.h"

#ifndef USERGEEK_LOG_WARN
#define USERGEEK_LOG_WARN 0
#endif

#ifndef USERGEEK_WARN
#if USERGEEK_LOG_WARN
#   define USERGEEK_WARN(fmt, ...) NSLog((@"USERGEEK_WARN: " fmt), ##__VA_ARGS__)
#else
#   define USERGEEK_WARN(...)
#endif
#endif

@interface UsergeekClientWrapper ()
@end

@implementation UsergeekClientWrapper

- (id <UsergeekClient>)setUserId:(NSString *)userId {
    if (![self.client setUserId:userId]) {
        USERGEEK_WARN(@"Ignore setUserId, statistics not initialized");
    }
    return self;
}

- (id <UsergeekClient>)resetUserId:(BOOL)regenerateDeviceId {
    if (![self.client resetUserId:regenerateDeviceId]) {
        USERGEEK_WARN(@"Ignore resetUserId, statistics not initialized");
    }
    return self;
}

- (id <UsergeekClient>)logUserProperties:(UsergeekUserProperties *)userProperties {
    if (![self.client logUserProperties:userProperties]) {
        USERGEEK_WARN(@"Ignore logUserProperties, statistics not initialized");
    }
    return self;
}

- (id <UsergeekClient>)logEvent:(NSString *)eventName {
    if (![self.client logEvent:eventName]) {
        USERGEEK_WARN(@"Ignore logEvent, statistics not initialized");
    }
    return self;
}

- (id <UsergeekClient>)logEvent:(NSString *)eventName eventProperties:(UsergeekEventProperties *_Nullable)eventProperties {
    if (![self.client logEvent:eventName eventProperties:eventProperties]) {
        USERGEEK_WARN(@"Ignore logEvent:eventProperties, statistics not initialized");
    }
    return self;
}

- (void)flush {
    [self.client flush];
}


@end