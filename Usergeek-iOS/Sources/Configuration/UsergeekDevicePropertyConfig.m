

#import <UIKit/UIKit.h>
#import "UsergeekDevicePropertyConfig.h"
#import "UsergeekDevicePropertyCacheSupplier.h"
#import "UsergeekDevicePropertyFactory.h"

@interface UsergeekDevicePropertyConfig ()
@property(nonatomic) NSMutableDictionary <NSString *, UsergeekDevicePropertySupplier *> *properties;
@end

@implementation UsergeekDevicePropertyConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.properties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)trackPlatform {
    return [self trackCacheProperty:@"platform" callback:^NSObject * {
        return @"ios";
    }];
}

- (instancetype)trackModel {
    return [self trackCacheProperty:@"model" callback:^NSObject * {
        return [UsergeekDevicePropertyFactory getHWMachine];
    }];
}

- (instancetype)trackBrand {
    return [self trackCacheProperty:@"brand" callback:^NSObject * {
        return @"Apple";
    }];
}

- (instancetype)trackManufacturer {
    return [self trackCacheProperty:@"manufacturer" callback:^NSObject * {
        return @"Apple";
    }];
}

- (instancetype)trackOsVersion {
    return [self trackCacheProperty:@"osVersion" callback:^NSObject * {
        return [[UIDevice currentDevice] systemVersion];
    }];
}

- (instancetype)trackAppVersion {
    return [self trackCacheProperty:@"appVersion" callback:^NSObject * {
        return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    }];
}

- (instancetype)trackCountry {
    return [self trackCacheProperty:@"country" callback:^NSObject * {
        return [UsergeekDevicePropertyFactory countryISOCode];
    }];
}

- (instancetype)trackLanguage {
    return [self trackCacheProperty:@"language" callback:^NSObject * {
        return [UsergeekDevicePropertyFactory language];
    }];
}

- (instancetype)trackCarrier {
    return [self trackCacheProperty:@"carrier" callback:^NSObject * {
        return [UsergeekDevicePropertyFactory carrier];
    }];
}

- (instancetype)trackCacheProperty:(NSString *)propertyName callback:(UsergeekDevicePropertySupplierGetValueCallback)callback {
    self.properties[propertyName] = [UsergeekDevicePropertyCacheSupplier supplierWithCallback:callback];
    return self;
}

- (instancetype)trackProperty:(NSString *)propertyName callback:(UsergeekDevicePropertySupplierGetValueCallback)callback {
    self.properties[propertyName] = [UsergeekDevicePropertySupplier supplierWithCallback:callback];
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToConfig:other];
}

- (BOOL)isEqualToConfig:(UsergeekDevicePropertyConfig *)config {
    if (self == config)
        return YES;
    if (config == nil)
        return NO;
    if (self.properties != config.properties && ![self.properties isEqualToDictionary:config.properties])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.properties hash];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.properties=%@", self.properties];
    [description appendString:@">"];
    return description;
}

@end