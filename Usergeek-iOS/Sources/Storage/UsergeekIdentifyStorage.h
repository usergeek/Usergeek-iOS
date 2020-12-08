

#import <Foundation/Foundation.h>

@class UsergeekConfiguration;

@interface UsergeekIdentifyStorage : NSObject

@property(nonatomic) NSString *deviceId;
@property(nonatomic) NSString *userId;

- (instancetype)initWithConfiguration:(UsergeekConfiguration *)configuration;

- (void)removeAllData;

@end