

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSObject *_Nullable (^UsergeekDevicePropertySupplierGetValueCallback)(void);

@protocol UsergeekDevicePropertySupplierProtocol <NSObject>
- (NSObject *)getValue;
@end

@interface UsergeekDevicePropertySupplier : NSObject <UsergeekDevicePropertySupplierProtocol>

+ (id <UsergeekDevicePropertySupplierProtocol>)supplierWithCallback:(UsergeekDevicePropertySupplierGetValueCallback)callback;

@end

NS_ASSUME_NONNULL_END
