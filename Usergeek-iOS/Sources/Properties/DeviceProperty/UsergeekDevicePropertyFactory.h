

#import <Foundation/Foundation.h>

@interface UsergeekDevicePropertyFactory : NSObject
+ (NSString *)getHWMachine;

+ (NSString *)countryISOCode;

+ (NSString *)language;

+ (NSString *)carrier;
@end