

#import "UsergeekIO.h"

@implementation UsergeekIO

+ (NSString *)rootDirPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)error {
    BOOL exists = [UsergeekIO fileExistsAtPath:path];
    if (exists) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    }
    return YES;
}

@end