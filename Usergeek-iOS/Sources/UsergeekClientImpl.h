

#import <Foundation/Foundation.h>
#import "UsergeekClient.h"

@class UsergeekInitConfig;

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekClientImpl : NSObject <UsergeekClient>

- (id <UsergeekClient>)initWithApiKey:(NSString *)apiKey initConfig:(UsergeekInitConfig *)initConfig;

@end

NS_ASSUME_NONNULL_END