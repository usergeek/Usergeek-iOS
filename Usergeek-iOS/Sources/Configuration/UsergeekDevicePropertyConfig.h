

#import <Foundation/Foundation.h>
#import "UsergeekDevicePropertySupplier.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekDevicePropertyConfig : NSObject
@property(nonatomic, readonly) NSMutableDictionary <NSString *, UsergeekDevicePropertySupplier *> *properties;

- (instancetype)trackPlatform;

- (instancetype)trackModel;

- (instancetype)trackBrand;

- (instancetype)trackManufacturer;

- (instancetype)trackOsVersion;

- (instancetype)trackAppVersion;

- (instancetype)trackCountry;

- (instancetype)trackLanguage;

- (instancetype)trackCarrier;

- (instancetype)trackCacheProperty:(NSString *)propertyName callback:(UsergeekDevicePropertySupplierGetValueCallback)callback;

- (instancetype)trackProperty:(NSString *)propertyName callback:(UsergeekDevicePropertySupplierGetValueCallback)callback;

@end

NS_ASSUME_NONNULL_END