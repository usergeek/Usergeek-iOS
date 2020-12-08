

#import <Foundation/Foundation.h>
#import "UsergeekBaseProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekUserProperties : UsergeekBaseProperties

+ (instancetype)instance;

- (instancetype)set:(NSString *_Nullable)value forKey:(NSString *)key;

- (instancetype)unset:(NSString *)key;

@end

NS_ASSUME_NONNULL_END