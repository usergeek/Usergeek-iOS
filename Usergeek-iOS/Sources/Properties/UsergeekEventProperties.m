

#import "UsergeekEventProperties.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UsergeekEventProperties

+ (instancetype)instance {
    return [[UsergeekEventProperties alloc] init];
}

- (instancetype)set:(id _Nullable)value forKey:(NSString *)key {
    if (key) {
        if (value) {
            self.properties[key] = value;
        } else {
            self.properties[key] = [NSNull null];
        }
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END