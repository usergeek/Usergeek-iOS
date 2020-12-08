#import "NSString+Test.h"

@implementation NSString (Test)

+ (NSString *)stringWithLength:(int)length {
    return [@"_" stringByPaddingToLength:(NSUInteger) length withString:@"_" startingAtIndex:0];
}

@end