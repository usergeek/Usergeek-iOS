

#import "UsergeekUserPropertyValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsergeekUserPropertyValue ()
@property(nonatomic, readwrite) NSString *operation;
@property(nonatomic, readwrite) NSObject *_Nullable value;
@end

@implementation UsergeekUserPropertyValue

- (instancetype)initWithOperation:(NSString *)operation value:(NSObject *_Nullable)value {
    self = [super init];
    if (self) {
        self.operation = operation;
        self.value = value;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END