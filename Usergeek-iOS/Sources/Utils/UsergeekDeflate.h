

#import <Foundation/Foundation.h>

@interface UsergeekDeflate : NSObject

+ (NSData *)usergeek_compress:(NSData *)data;

+ (NSData *)usergeek_decompress:(NSData *)data;

@end