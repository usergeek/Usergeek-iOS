

#import "Usergeek.h"
#import "UsergeekClientWrapper.h"
#import "UsergeekClientImpl.h"

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

@interface Usergeek ()
@property(nonatomic) UsergeekClientWrapper *clientWrapper;
@end

@implementation Usergeek

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clientWrapper = [[UsergeekClientWrapper alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static Usergeek *_id = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _id = [[Usergeek alloc] init];
    });
    return _id;
}

- (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey {
    return [self initializeWithApiKey:apiKey initConfig:[[UsergeekInitConfig alloc] init]];
}

+ (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey {
    return [[Usergeek sharedInstance] initializeWithApiKey:apiKey];
}

- (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig {
    UsergeekClientWrapper *clientWrapper = self.clientWrapper;
    if (clientWrapper.client) {
        USERGEEK_WARN(@"Ignore initialize. Statistics yet initialized.");
    } else {
        clientWrapper.client = [[UsergeekClientImpl alloc] initWithApiKey:apiKey initConfig:initConfig];
    }
    return clientWrapper;
}

+ (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig {
    return [[Usergeek sharedInstance] initializeWithApiKey:apiKey initConfig:initConfig];
}

- (id <UsergeekClient>)getClient {
    return self.clientWrapper;
}

+ (id <UsergeekClient>)getClient {
    return [[Usergeek sharedInstance] getClient];
}

#pragma mark Client

+ (id <UsergeekClient>)setUserId:(NSString *)userId {
    return [[Usergeek getClient] setUserId:userId];
}

+ (id <UsergeekClient>)resetUserId:(BOOL)regenerateDeviceId {
    return [[Usergeek getClient] resetUserId:regenerateDeviceId];
}

+ (id <UsergeekClient>)logUserProperties:(UsergeekUserProperties *)userProperties {
    return [[Usergeek getClient] logUserProperties:userProperties];
}

+ (id <UsergeekClient>)logEvent:(NSString *)eventName {
    return [[Usergeek getClient] logEvent:eventName];
}

+ (id <UsergeekClient>)logEvent:(NSString *)eventName eventProperties:(UsergeekEventProperties *)eventProperties {
    return [[Usergeek getClient] logEvent:eventName eventProperties:eventProperties];
}

+ (void)flush {
    [[Usergeek getClient] flush];
}

@end
