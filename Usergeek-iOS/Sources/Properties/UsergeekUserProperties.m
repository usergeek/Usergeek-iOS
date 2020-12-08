

#import "UsergeekUserProperties.h"
#import "UsergeekFormats.h"
#import "UsergeekUserPropertyValue.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UsergeekUserProperties

+ (instancetype)instance {
    return [[UsergeekUserProperties alloc] init];
}

- (instancetype)set:(NSString *_Nullable)value forKey:(NSString *)key {
    if (key) {
        UsergeekUserPropertyValue *userPropertiesValue = [[UsergeekUserPropertyValue alloc] initWithOperation:USERGEEK__PROPERTY_OPERATION__SET value:value];
        self.properties[key] = userPropertiesValue;
    }
    return self;
}

- (instancetype)unset:(NSString *)key {
    if (key) {
        UsergeekUserPropertyValue *userPropertiesValue = [[UsergeekUserPropertyValue alloc] initWithOperation:USERGEEK__PROPERTY_OPERATION__UNSET value:[NSNull null]];
        self.properties[key] = userPropertiesValue;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END