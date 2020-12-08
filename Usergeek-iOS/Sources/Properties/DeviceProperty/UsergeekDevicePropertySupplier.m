

#import "UsergeekDevicePropertySupplier.h"

@interface UsergeekDevicePropertySupplier ()
@property(nonatomic, readwrite, copy) UsergeekDevicePropertySupplierGetValueCallback callback;
@end

@implementation UsergeekDevicePropertySupplier

- (instancetype)initWithCallback:(UsergeekDevicePropertySupplierGetValueCallback)callback {
    self = [super init];
    if (self) {
        self.callback = callback;
    }
    return self;
}

+ (id <UsergeekDevicePropertySupplierProtocol>)supplierWithCallback:(UsergeekDevicePropertySupplierGetValueCallback)callback {
    return [[self alloc] initWithCallback:callback];
}

#pragma mark UsergeekDevicePropertySupplierProtocol

NS_ASSUME_NONNULL_BEGIN

- (NSObject *)getValue {
    if (self.callback) {
        return self.callback();
    }
    return nil;
}

NS_ASSUME_NONNULL_END

@end
