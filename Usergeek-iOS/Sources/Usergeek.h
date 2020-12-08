

#import <Foundation/Foundation.h>
#import "UsergeekClient.h"
#import "UsergeekInitConfig.h"
#import "UsergeekEventProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface Usergeek : NSObject

+ (instancetype)sharedInstance;

+ (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey;

- (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey;

+ (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig;

- (id <UsergeekClient>)initializeWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig;

+ (id <UsergeekClient>)getClient;

- (id <UsergeekClient>)getClient;

#pragma mark Client

+ (id <UsergeekClient>)setUserId:(NSString *)userId;

+ (id <UsergeekClient>)resetUserId:(BOOL)regenerateDeviceId;

+ (id <UsergeekClient>)logUserProperties:(UsergeekUserProperties *)userProperties;

+ (id <UsergeekClient>)logEvent:(NSString *)eventName;

+ (id <UsergeekClient>)logEvent:(NSString *)eventName eventProperties:(UsergeekEventProperties *)eventProperties;

+ (void)flush;

@end

NS_ASSUME_NONNULL_END
