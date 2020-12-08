

#import "UsergeekBaseProperties.h"

@interface UsergeekBaseProperties ()
@property(nonatomic, readwrite) NSMutableDictionary <NSString *, NSObject *> *properties;
@end

@implementation UsergeekBaseProperties

- (instancetype)init {
    self = [super init];
    if (self) {
        self.properties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end