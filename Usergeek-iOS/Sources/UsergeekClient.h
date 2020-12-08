

#import <Foundation/Foundation.h>
#import "UsergeekEventProperties.h"
#import "UsergeekUserProperties.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UsergeekClient <NSObject>

- (id <UsergeekClient>)setUserId:(NSString *)userId;

- (id <UsergeekClient>)resetUserId:(BOOL)regenerateDeviceId;

- (id <UsergeekClient>)logUserProperties:(UsergeekUserProperties *)userProperties;

- (id <UsergeekClient>)logEvent:(NSString *)eventName;

- (id <UsergeekClient>)logEvent:(NSString *)eventName eventProperties:(UsergeekEventProperties *_Nullable)eventProperties;

- (void)flush;

@end

NS_ASSUME_NONNULL_END