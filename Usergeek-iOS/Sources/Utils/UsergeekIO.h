

#import <Foundation/Foundation.h>

@interface UsergeekIO : NSObject
@property(nonatomic, readonly, class) NSString *rootDirPath;

+ (BOOL)fileExistsAtPath:(NSString *)path;

+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)error;

@end